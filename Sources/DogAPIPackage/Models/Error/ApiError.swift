//
//  File.swift
//  
//
//  Created by Martin Dimitrov on 2.05.23.
//

import Foundation

struct ApiError: Error {
    let message: String
}

extension ApiError {
    static let invalidURL = Self.init(message: "Invalid URL")
    static let unknown = Self.init(message: "Unknown Error")
    static let invalidResponse = Self.init(message: "Invalid Response")
}
