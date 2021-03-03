//
//  ApiManager.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 12/02/21.
//

import Foundation

class ApiManager: InstrumentsManagerLogger {
    
    private let apiProvider: ApiClient?
    
    init(apiClient: ApiClient? = nil) {
        self.apiProvider = apiClient
    }
    
    func listBreweries(page: Int, completion: @escaping FetchBreweryCompletion) {
        startLog()
        addOperation(
            ApiOperation(page: page, apiClient: self.apiProvider) { result in
                self.endLog()
                NSLog("Manager - Brew - Done")
                completion(result)
            }
        )
    }
    
    private func listHolidays(completion: @escaping FetchHolidaysCompletion) {
        addOperation(
            ApiHolidayOperation(apiClient: self.apiProvider) { result in
                NSLog("Manager - Holiday - Done")
                completion(result)
            }
        )
    }
    
    func listBreweriesAndHolidays(page: Int, completion: @escaping FetchFullListCompletion) {
        var breweries: [Brewery] = []
        var holidays: [Holiday] = []
        
        let opBrew = ApiOperation(page: page, apiClient: self.apiProvider) { brewResponse in
            if let brewList = unwrapResult(input: brewResponse) {
                breweries = brewList
            }
        }
        
        let opHoliday = ApiHolidayOperation(apiClient: self.apiProvider) { holidayResponse in
            if let holidayList = unwrapResult(input: holidayResponse) {
                holidays = holidayList
            }
        }
        
        let parseOperation = BlockOperation {
            NSLog("Service - Full - Done")
            let reponse = ModelResponse(breweryList: breweries, holidayList: holidays)
            // MARK: PARA FUNCIONAR NA MAIN THREAD
            OperationQueue.main.addOperation {
                completion(.success(reponse))
            }
        }

        parseOperation.addDependency(opBrew)
        parseOperation.addDependency(opHoliday)
        
        addOperations([opBrew, opHoliday, parseOperation], waitUntilFinished: false)
    }
}
