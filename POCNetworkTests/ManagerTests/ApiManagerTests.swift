//
//  ApiManagerTests.swift
//  POCNetworkTests
//
//  Created by Lucas Ramos Maciel on 18/02/21.
//

import XCTest
@testable import POCNetwork

class ApiManagerTests: XCTestCase {
    
    var manager: ApiManager!
    var apiClient: ApiClient!
    
    func testeSucessoBrewsListaCompleta() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada do manager")
        apiClient = ApiClient(env: .test)
        manager = ApiManager(apiClient: apiClient)
        
        // WHEN
        manager.listBreweries(page: 1){ response in
            
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
    
    func testeSucessoBrewsHolidaysListaCompleta() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada do manager")
        apiClient = ApiClient(env: .test)
        manager = ApiManager(apiClient: apiClient)

        // WHEN
        manager.listBreweriesAndHolidays(page: 1) { response in
            
            // THEN
            switch response {
            case .success(let model):
                XCTAssertEqual(model.breweryList.count, 2)
                XCTAssertEqual(model.holidayList.count, 2)
            case .failure(_):
                XCTFail("Deveria retornar duas listas não vazias")
            }
            serviceExpectation.fulfill()
        }
        wait(for: [serviceExpectation], timeout: 3.0)
    }
    
    // MARK: TEMOS QUE PILOTAR O API CLIENT?
    func testeSucessoBrewsHolidaysListaVazia() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada do manager")
        apiClient = ApiClient(env: .test)
        manager = ApiManager(apiClient: apiClient)

        // WHEN
        manager.listBreweriesAndHolidays(page: 1) { response in

            // THEN
            switch response {
            case .success(let model):
                XCTAssertEqual(model.breweryList.count, 0)
                XCTAssertEqual(model.holidayList.count, 0)
            case .failure(_):
                XCTFail("Deveria retornar duas listas não vazias")
            }
            serviceExpectation.fulfill()
        }
        wait(for: [serviceExpectation], timeout: 3.0)
    }
    
    func testeErroBrews() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada do manager")
        apiClient = ApiClient(env: .testError)
        manager = ApiManager(apiClient: apiClient)
        
        // WHEN
        manager.listBreweries(page: 1){ response in
            
            // THEN
            switch response {
            case .success(_):
                XCTFail("Deveria retornar erro")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 500)
            }
            serviceExpectation.fulfill()
        }
        wait(for: [serviceExpectation], timeout: 3.0)
    }
}
