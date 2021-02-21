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


    
    
    
    
    
    
    
    
    
    
    // TODO: APAGAR
    
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
