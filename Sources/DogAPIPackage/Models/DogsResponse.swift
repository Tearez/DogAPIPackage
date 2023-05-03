//
//  File.swift
//  
//
//  Created by Martin Dimitrov on 2.05.23.
//

import Foundation

struct DogsResponse: Decodable {
    let message: [String]
    let status: String
}
