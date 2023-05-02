//
//  File.swift
//  
//
//  Created by Martin Dimitrov on 2.05.23.
//

import Foundation

enum Path {
    case random
    case count(Int)
    
    var description: String {
        switch self {
        case .random:
            return "random"
        case .count(let count):
            return "\(count)"
        }
    }
}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

protocol ApiClientProtocol {
    func executeRequest<T: Decodable>(_ method: RequestMethod, at paths: [Path]) async throws -> T
}

final class ApiClient: ApiClientProtocol {
    private enum Constants {
        static let dogApi = "https://dog.ceo/api/breeds/image/"
    }
    
    func executeRequest<T: Decodable>(_ method: RequestMethod, at paths: [Path]) async throws -> T {
        guard let url = URL(string: buildUrl(paths)) else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse
        }
        
        switch response.statusCode {
        case 200...299:
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        default:
            throw ApiError.unknown
        }
    }
    
    private func buildUrl(_ paths: [Path]) -> String {
        let path = paths.map { $0.description }.joined(separator: "/")
        return Constants.dogApi + path
    }
}
