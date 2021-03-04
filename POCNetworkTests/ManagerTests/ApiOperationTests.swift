//
//  ApiOperationTests.swift
//  POCNetworkTests
//
//  Created by Lucas Ramos Maciel on 18/02/21.
//

import XCTest

@testable import POCNetwork

class ApiOperationTests: XCTestCase {

    var operation: ApiOperation!
    var apiClient: ApiClient!
    
    func testeSucessoListaCompleta() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada de serviço")
        apiClient = ApiClient(env: .test)
        operation = ApiOperation(page: 1, apiClient: apiClient) { response in
            
            // THEN
            switch response {
            case .success(let list):
                XCTAssertEqual(list.count, 2)
                XCTAssertEqual(list[1].name, "Cervejaria2")
            case .failure(_):
                XCTFail("Deveria retornar uma lista não vazia")
            }
            serviceExpectation.fulfill()
        }
        
        // WHEN
        
        // Sync
        operation.main()
        
        // Async
        //OperationQueue.main.addOperation(operation)
        //wait(for: [serviceExpectation], timeout: 3.0)
    }
    
    func testeErro() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada de serviço")
        apiClient = ApiClient(env: .testError)
        operation = ApiOperation(page: 1, apiClient: apiClient) { response in
            
            // THEN
            switch response {
            case .success(_):
                XCTFail("Deveria retornar erro")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 500)
            }
            serviceExpectation.fulfill()
        }
        
        // WHEN
        
        // Sync
        operation.main()
        
        // Async
        //OperationQueue.main.addOperation(operation)
        //wait(for: [serviceExpectation], timeout: 3.0)
    }
}
