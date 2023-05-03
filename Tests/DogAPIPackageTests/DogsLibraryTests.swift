//
//  DogsLibraryTests.swift
//  
//
//  Created by Martin Dimitrov on 3.05.23.
//

import XCTest
@testable import DogAPIPackage

final class DogsLibraryTests: XCTestCase {
    
    private var apiClient: ApiClientMock!
    private var dogsLibrary: DogsLibrary!

    override func setUp() {
        super.setUp()
        apiClient = ApiClientMock()
        dogsLibrary = DogsLibrary(apiClient: apiClient)
    }
    
    func testGetImageSuccess() async throws {
        apiClient.executeRequestHandler = { method, paths in
            XCTAssertEqual(method, .get)
            XCTAssertEqual(paths, [.random])
            
            return DogResponse.mock1
        }
        
        let result = try await dogsLibrary.getImage()
        XCTAssertEqual(result.url, DogResponse.mock1.message)
        XCTAssertEqual(apiClient.executeRequestCallCount, 1)
    }
    
    func testGetImageFail() async throws {
        apiClient.executeRequestHandler = { method, paths in
            XCTAssertEqual(method, .get)
            XCTAssertEqual(paths, [.random])
            throw ApiError(message: "test")
        }
        
        do {
            _ = try await dogsLibrary.getImage()
            XCTFail("Api client should have thrown an error")
        } catch let error {
            guard let apiError = try? XCTUnwrap(error as? ApiError) else {
                XCTFail("Error Should have been of type ApiError")
                return
            }
            XCTAssertEqual(apiError.message, "test")
        }
    }
    
    func testGetImagesSuccess() async throws {
        let expectedResult = DogsResponse.mock.message

        apiClient.executeRequestHandler = { method, paths in
            XCTAssertEqual(method, .get)
            XCTAssertEqual(paths, [.random, .count(5)])
            
            return DogsResponse.mock
        }
        
        let result = try await dogsLibrary.getImages(5)
        let resultUrls = result.map { $0.url }
        XCTAssertEqual(resultUrls, expectedResult)
        XCTAssertEqual(apiClient.executeRequestCallCount, 1)
    }
    
    func testGetImagesFail() async throws {
        apiClient.executeRequestHandler = { method, paths in
            XCTAssertEqual(method, .get)
            XCTAssertEqual(paths, [.random, .count(5)])
            throw ApiError(message: "test")
        }
        
        do {
            _ = try await dogsLibrary.getImages(5)
            XCTFail("Api client should have thrown an error")
        } catch let error {
            guard let apiError = try? XCTUnwrap(error as? ApiError) else {
                XCTFail("Error Should have been of type ApiError")
                return
            }
            XCTAssertEqual(apiError.message, "test")
        }
    }
    
    func testGetNextImageSuccess() async throws {
        apiClient.executeRequestHandler = { method, paths in
            XCTAssertEqual(method, .get)
            XCTAssertEqual(paths, [.random])
            
            return DogResponse.mock1
        }
        
        let result1 = try await dogsLibrary.getNextImage()
        XCTAssertEqual(result1.url, DogResponse.mock1.message)
        XCTAssertEqual(apiClient.executeRequestCallCount, 1)
        
        apiClient.executeRequestHandler = { method, paths in
            XCTAssertEqual(method, .get)
            XCTAssertEqual(paths, [.random])
            
            return DogResponse.mock2
        }
        
        let result2 = try await dogsLibrary.getNextImage()
        XCTAssertEqual(result2.url, DogResponse.mock2.message)
        XCTAssertEqual(apiClient.executeRequestCallCount, 2)
    }
    
    func testGetNextImageFail() async throws {
        apiClient.executeRequestHandler = { method, paths in
            XCTAssertEqual(method, .get)
            XCTAssertEqual(paths, [.random])
            
            throw ApiError(message: "test")
        }
        
        do {
            _ = try await dogsLibrary.getImage()
            XCTFail("Api client should have thrown an error")
        } catch let error {
            guard let apiError = try? XCTUnwrap(error as? ApiError) else {
                XCTFail("Error Should have been of type ApiError")
                return
            }
            XCTAssertEqual(apiError.message, "test")
        }
        
        apiClient.executeRequestHandler = { method, paths in
            XCTAssertEqual(method, .get)
            XCTAssertEqual(paths, [.random])
            
            return DogResponse.mock2
        }
        
        let result2 = try await dogsLibrary.getNextImage()
        XCTAssertEqual(result2.url, DogResponse.mock2.message)
        XCTAssertEqual(apiClient.executeRequestCallCount, 2)
    }
    
    func testGetPreviousImage() async throws {
        let result1 = dogsLibrary.getPreviousImage()
        XCTAssertNil(result1)
        
        apiClient.executeRequestHandler = { _, _ in
            return DogResponse.mock1
        }
        let _ = try await dogsLibrary.getNextImage()
        
        let result2 = dogsLibrary.getPreviousImage()
        XCTAssertNotNil(result2)
        XCTAssertEqual(result2?.url, DogResponse.mock1.message)
        
        apiClient.executeRequestHandler = { _, _ in
            return DogResponse.mock2
        }
        let _ = try await dogsLibrary.getNextImage()
        
        let result3 = dogsLibrary.getPreviousImage()
        XCTAssertNotNil(result3)
        XCTAssertEqual(result3?.url, DogResponse.mock1.message)
    }
}

extension Path: Equatable {
    public static func == (lhs: Path, rhs: Path) -> Bool {
        switch (lhs, rhs) {
        case (.random, .count):
            return false
        case (.count, .random):
            return false
        case (.random, .random):
            return true
        case (.count(let lhsCount), .count(let rhsCount)):
            return lhsCount == rhsCount
        }
    }
}

extension DogResponse {
    static let mock1 = DogResponse(message: "https://example.com/test1", status: "success")
    static let mock2 = DogResponse(message: "https://example.com/test2", status: "success")
}

extension DogsResponse {
    static let mock = DogsResponse(message: ["https://example.com/test1",
                                            "https://example.com/test2",
                                            "https://example.com/test3"], status: "success")
}
