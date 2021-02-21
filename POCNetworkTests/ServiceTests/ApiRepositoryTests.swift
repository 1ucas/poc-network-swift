//
//  ApiRepositoryTests.swift
//  POCNetworkTests
//
//  Created by Lucas Ramos Maciel on 18/02/21.
//

import XCTest
import Foundation

@testable import POCNetwork

class ApiRepositoryTests: XCTestCase {
    
    var repository: ApiRepository!
    var apiClient: ApiClient!
    
    func testeServer() {
        // GIVEN
        let page = 1
        let serviceExpectation = XCTestExpectation(description: "Chamada de serviço teste server")

        repository = ApiRepository()
        runServer {
            ApiMockServer.registerResponse(route: "/breweries?per_page=20&page=\(page)", object: ApiClient.mockBrewList)
        }
        
        // WHEN
        repository.listBreweries(page: page) { response in
            
            // THEN
            switch response {
            case .success(let list):
                XCTAssertEqual(list.count, 2)
                XCTAssertEqual(list[1].name, "Cervejaria2")
            case .failure(let error):
                XCTFail("Deveria retornar uma lista não vazia \(error)")
            }
            serviceExpectation.fulfill()
        }
        wait(for: [serviceExpectation], timeout: 3.0)
    }
    
    func testeErro() {
        // GIVEN
        apiClient = ApiClient(env: .testError)
        repository = ApiRepository(apiClient: apiClient)
        
        // WHEN
        repository.listBreweries(page: 1) { response in
            
            // THEN
            switch response {
            case .success(_):
                XCTFail("Deveria retornar erro")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 500)
            }
        }
        
    }
    
    func testeSucessoListaCompleta() {
        // GIVEN
        apiClient = ApiClient(env: .test)
        repository = ApiRepository(apiClient: apiClient)
        
        // WHEN
        repository.listBreweries(page: 1) { response in
            
            // THEN
            switch response {
            case .success(let list):
                XCTAssertEqual(list.count, 2)
                XCTAssertEqual(list[1].name, "Cervejaria2")
            case .failure(_):
                XCTFail("Deveria retornar uma lista não vazia")
            }
        }
    }
    
    private func runServer(registrations: () -> Void) {
        registrations()
        ApiMockServer.start()
    }

}
