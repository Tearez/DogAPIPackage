//
//  File.swift
//  
//
//  Created by Martin Dimitrov on 2.05.23.
//

import Foundation

public struct LibraryModel: Identifiable {
    public let id: String = UUID().uuidString
    public let url: String
}

public final class DogsLibrary: ObservableObject {
    private var models: [LibraryModel]
    private let apiClient: ApiClientProtocol
    private var currentIndex: Int = .zero
    
    public init() {
        self.models = []
        self.apiClient = ApiClient()
    }
    
    public func getImage() async throws -> LibraryModel {
        let response: DogResponse = try await apiClient.executeRequest(.get, at: [.random])
        let model = LibraryModel(url: response.message)
        return model
    }
    
    public func getImages(_ count: Int) async throws -> [LibraryModel] {
        let response: DogsResponse = try await apiClient.executeRequest(.get, at: [.random, .count(count)])
        
        let newModels = response.message.map { LibraryModel(url: $0) }
        return newModels
    }
    
    public func getNextImage() async throws -> LibraryModel {
        if currentIndex == models.endIndex {
            let newImage = try await getImage()
            models.append(newImage)
            currentIndex = models.endIndex
            return newImage
        } else {
            currentIndex += 1
            return models[currentIndex]
        }
    }
    
    public func getPreviousImage() async throws -> LibraryModel? {
        if models.isEmpty || currentIndex == models.startIndex {
            return nil
        } else {
            currentIndex -= 1
            return models[currentIndex]
        }
    }
}
