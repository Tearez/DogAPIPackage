//
//  File.swift
//  
//
//  Created by Martin Dimitrov on 2.05.23.
//

import Foundation

struct DogsResponse: Decodable {
    public let message: [String]
    public let status: String
}
