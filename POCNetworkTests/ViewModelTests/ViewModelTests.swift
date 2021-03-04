//
//  ViewModelTests.swift
//  POCNetworkTests
//
//  Created by Lucas Ramos Maciel on 03/03/21.
//

import XCTest
@testable import POCNetwork

class ViewModelTests: XCTestCase {
    
    var viewModelDireto: ViewModelDireto!
    var viewModelOperation: ViewModelOperation!
    
    var apiService: ApiServiceProtocol!
    var apiManager: ApiManager!
    
    func testeSucessoComInterface() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada do Service")
        apiService = ApiServiceMock()
        viewModelDireto = ViewModelDireto(apiService: apiService)
        
        // WHEN
        viewModelDireto.listBreweries(page: 1){ response in
            
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
        wait(for: [serviceExpectation], timeout: 3.0)
    }
    
    func testeSucessoSemInterface() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada do Manager")
        
        let apiClientMock = ApiClient(env: .test)
        apiManager = ApiManager(apiClient: apiClientMock)
        viewModelOperation = ViewModelOperation(apiManager: apiManager)
        
        // WHEN
        viewModelOperation.listBreweries(page: 1){ response in
            
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
        wait(for: [serviceExpectation], timeout: 3.0)
    }
}
