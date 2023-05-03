//
//  File.swift
//  
//
//  Created by Martin Dimitrov on 3.05.23.
//

import Foundation
@testable import DogAPIPackage

final class ApiClientMock: ApiClientProtocol {
    
    var executeRequestHandler: ((RequestMethod, [Path]) async throws -> Decodable)
    private(set) var executeRequestCallCount: Int = 0
    
    init() {
        self.executeRequestHandler = { _,_ in "" }
    }
    
    func executeRequest<T>(_ method: RequestMethod, at paths: [Path]) async throws -> T where T : Decodable {
        executeRequestCallCount += 1
        return try await executeRequestHandler(method, paths) as! T
    }
}
