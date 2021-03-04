//
//  ApiService.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 12/02/21.
//

import Foundation

class ApiService : InstrumentsServiceLogger, ApiServiceProtocol {
    
    private let repository: ApiRepositoryProtocol
    
    init(repository: ApiRepositoryProtocol = ApiRepository()) {
        self.repository = repository
    }
    
    func listBreweries(page: Int, completion: @escaping FetchBreweryCompletion) {
        startLog()
        repository.listBreweries(page: page) { response in
            self.endLog()
            NSLog("Service - Brew - Done")
            completion(response)
        }
    }
    
    
    
    private func listHolidays(completion: @escaping FetchHolidaysCompletion) {
        repository.listHolidays() { response in
            NSLog("Service - Holiday - Done")
            completion(response)
        }
    }
    
    
    
    func listBreweriesAndHolidays(page: Int, completion: @escaping FetchFullListCompletion) {
        var breweries: [Brewery] = []
        var holidays: [Holiday] = []
        
        self.listBreweries(page: page) { brewResponse in
            if let brewList = unwrapResult(input: brewResponse) {
                breweries = brewList
            }
            self.listHolidays { holidayResponse in
                if let holidayList = unwrapResult(input: holidayResponse) {
                    holidays = holidayList
                }
                NSLog("Service - Full - Done")
                let reponse = ModelResponse(breweryList: breweries, holidayList: holidays)
                completion(.success(reponse))
            }
        }
    }
}

protocol ApiServiceProtocol {
    func listBreweries(page: Int, completion: @escaping FetchBreweryCompletion)
}
