//
//  ApiServiceManager.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 03/03/21.
//

import Foundation

class ApiServiceManager : ApiService {
    
    private let operationQueue = OperationQueue()
    
    private let repository: ApiRepositoryProtocol
    
    override init(repository: ApiRepositoryProtocol = ApiRepository()) {
        self.repository = repository
    }

    override func listBreweriesAndHolidays(page: Int, completion: @escaping FetchFullListCompletion) {
        var breweries: [Brewery] = []
        var holidays: [Holiday] = []
        
        let opBrew = AsynchronousBlockOperation { finish in
            self.repository.listBreweries(page: page) { response in
                if let brewList = unwrapResult(input: response) {
                    breweries = brewList
                }
                finish()
            }
        }
        
        let opHoliday = AsynchronousBlockOperation { finish in
            self.repository.listHolidays { response in
                if let holidayList = unwrapResult(input: response) {
                    holidays = holidayList
                }
                finish()
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
        
        operationQueue.addOperations([opBrew, opHoliday, parseOperation], waitUntilFinished: false)
    }
    
    
    
    
    // MARK: Alternativa com CustomOperations
    
     
    //Private Operations
    
    private class BrewOperation : AsynchronousOperation {

        private let apiRepository: ApiRepositoryProtocol
        private let completion: FetchBreweryCompletion
        private let page: Int

        init(apiRepository: ApiRepositoryProtocol, page:Int, completion: @escaping FetchBreweryCompletion) {
            self.apiRepository = apiRepository
            self.page = page
            self.completion = completion
        }

        override func main() {
            apiRepository.listBreweries(page: page) { response in
                self.completion(response)
                self.finish()
            }
        }
    }

    private class HolidayOperation : AsynchronousOperation {

        private let apiRepository: ApiRepositoryProtocol
        private let completion: FetchHolidaysCompletion

        init(apiRepository: ApiRepositoryProtocol, completion: @escaping FetchHolidaysCompletion) {
            self.apiRepository = apiRepository
            self.completion = completion
        }

        override func main() {
            apiRepository.listHolidays { response in
                self.completion(response)
                self.finish()
            }
        }
    }
    
    // MARK: Custom Operations
    func listBreweriesAndHolidaysV2(page: Int, completion: @escaping FetchFullListCompletion) {
        var breweries: [Brewery] = []
        var holidays: [Holiday] = []
        
        let opBrew = BrewOperation(apiRepository: repository, page: page) { brewResponse in
            if let brewList = unwrapResult(input: brewResponse) {
                breweries = brewList
            }
        }

        let opHoliday = HolidayOperation(apiRepository: repository) { holidayResponse in
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
        
        operationQueue.addOperations([opBrew, opHoliday, parseOperation], waitUntilFinished: false)
    }
}
