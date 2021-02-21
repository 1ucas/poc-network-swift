//
//  ApiService.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 12/02/21.
//

import Foundation

class ApiService {

    private let repository: ApiRepositoryProtocol
    
    init(repository: ApiRepositoryProtocol = ApiRepository()) {
        self.repository = repository
    }
        
    func listBreweriesAndHolidays(page: Int, completion: @escaping FetchFullListCompletion) {
        var breweries: [Brewery] = []
        var holidays: [Holiday] = []
        
        self.listBreweries(page: page) { brewResponse in
            if let brewList = self.unwrapResult(input: brewResponse) {
                breweries = brewList
            }
            self.listHolidays { holidayResponse in
                if let holidayList = self.unwrapResult(input: holidayResponse) {
                    holidays = holidayList
                }
                NSLog("Service - Full - Done")
                let reponse = ModelResponse(breweryList: breweries, holidayList: holidays)
                completion(.success(reponse))
            }
        }
    }
    
    func listBreweries(page: Int, completion: @escaping FetchBreweryCompletion) {
        repository.listBreweries(page: page) { response in
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
    
    private func unwrapResult<T>(input: Result<T,Error>) -> T? {
        switch input {
        case .success(let item):
            return item
        case .failure(_):
            return nil
        }
    }
}
