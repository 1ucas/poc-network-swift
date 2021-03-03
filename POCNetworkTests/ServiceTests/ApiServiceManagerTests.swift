//
//  ApiServiceManagerTests.swift
//  POCNetworkTests
//
//  Created by Lucas Ramos Maciel on 03/03/21.
//

import XCTest
import Foundation

@testable import POCNetwork

class ApiServiceManagerTests: XCTestCase {

    var repo: ApiRepositoryMock!
    var service: ApiServiceManager!
    
    func testeSucessoBrewsHolidaysComOperation() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada de serviço teste server")
        repo = ApiRepositoryMock(mockStateBrew: .sucessTwo, mockStateHoliday: .sucessTwo)
        service = ApiServiceManager(repository: repo)
        
        // WHEN
        service.listBreweriesAndHolidays(page: 1) { response in
            
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
        wait(for: [serviceExpectation], timeout: 15.0)

    }
    
    func testeSucessoBrewsHolidaysCustomOperation() {
        // GIVEN
        let serviceExpectation = XCTestExpectation(description: "Chamada de serviço teste server")
        repo = ApiRepositoryMock(mockStateBrew: .sucessTwo, mockStateHoliday: .sucessTwo)
        service = ApiServiceManager(repository: repo)
        
        // WHEN
        service.listBreweriesAndHolidaysV2(page: 1) { response in
            
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
        wait(for: [serviceExpectation], timeout: 15.0)

    }
}
