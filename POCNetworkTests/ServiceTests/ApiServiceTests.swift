//
//  ApiServiceTests.swift
//  POCNetworkTests
//
//  Created by Lucas Ramos Maciel on 18/02/21.
//

import XCTest
import Foundation

@testable import POCNetwork


class ApiServiceTests: XCTestCase {
    
    var repo: ApiRepositoryMock!
    var service: ApiService!
    
    func testeSucessoBrewsListaCompleta() {
        // GIVEN
        repo = ApiRepositoryMock(mockStateBrew: .sucessTwo, mockStateHoliday: .apiError)
        service = ApiService(repository: repo)
        
        // WHEN
        service.listBreweries(page: 1) { response in
            
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
    
    func testeSucessoBrewsHolidaysListaCompleta() {
        // GIVEN
        repo = ApiRepositoryMock(mockStateBrew: .sucessTwo, mockStateHoliday: .sucessTwo)
        service = ApiService(repository: repo)
        
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
        }
    }
    
    func testeSucessoBrewsHolidaysListaVazia() {
        // GIVEN
        repo = ApiRepositoryMock(mockStateBrew: .emptyList, mockStateHoliday: .emptyList)
        service = ApiService(repository: repo)
        
        // WHEN
        service.listBreweriesAndHolidays(page: 1) { response in
            
            // THEN
            switch response {
            case .success(let model):
                XCTAssertEqual(model.breweryList.count, 0)
                XCTAssertEqual(model.holidayList.count, 0)
            case .failure(_):
                XCTFail("Deveria retornar duas listas vazias")
            }
        }
    }
    
    func testeErroBrews() {
        // GIVEN
        repo = ApiRepositoryMock(mockStateBrew: .apiError, mockStateHoliday: .apiError)
        service = ApiService(repository: repo)
        
        // WHEN
        service.listBreweries(page: 1) { response in
            
            // THEN
            switch response {
            case .success(_):
                XCTFail("Deveria retornar erro")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 500)
            }
        }
    }
}
