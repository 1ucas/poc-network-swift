//
//  ApiService.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 12/02/21.
//

import Foundation
import os.log

class ApiService {

    private let repository: ApiRepositoryProtocol
    private let operationQueue = OperationQueue()
    private static let pointsOfInterest = OSLog(subsystem: "RepositoryPOI", category: .pointsOfInterest)
    private let id = OSSignpostID(log: ApiService.pointsOfInterest)

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
        os_signpost(.begin, log: ApiService.pointsOfInterest, name: "REPO CALL", signpostID: id)
        repository.listBreweries(page: page) { response in
            os_signpost(.end, log: ApiService.pointsOfInterest, name: "REPO CALL", signpostID: self.id)
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
    
    
    // Private Operations

//    private class BrewOperation : Operation {
//
//        private let apiRepository: ApiRepositoryProtocol
//        private let completion: FetchBreweryCompletion
//        private let page: Int
//
//        init(apiRepository: ApiRepositoryProtocol, page:Int, completion: @escaping FetchBreweryCompletion) {
//            self.apiRepository = apiRepository
//            self.page = page
//            self.completion = completion
//        }
//
//        override func main() {
//            apiRepository.listBreweries(page: page, completion: completion)
//        }
//    }
//    
//    private class HolidayOperation : AsynchronousOperation {
//
//        private let apiRepository: ApiRepositoryProtocol
//        private let completion: FetchHolidaysCompletion
//
//        init(apiRepository: ApiRepositoryProtocol, completion: @escaping FetchHolidaysCompletion) {
//            self.apiRepository = apiRepository
//            self.completion = completion
//        }
//
//        override func main() {
//            apiRepository.listHolidays(completion: completion)
//        }
//    }
    
    // TODO: Implementar operation com service
    // func listBreweriesAndHolidaysWithOperation(page: Int, completion: @escaping FetchFullListCompletion) {
    //        var breweries: [Brewery] = []
    //        var holidays: [Holiday] = []
    //
    //        let opBrew = BrewOperation(apiRepository: repository, page: page) { brewResponse in
    //            if let brewList = self.unwrapResult(input: brewResponse) {
    //                breweries = brewList
    //            }
    //        }
    //
    //        let opHoliday = HolidayOperation(apiRepository: repository) { holidayResponse in
    //            if let holidayList = self.unwrapResult(input: holidayResponse) {
    //                holidays = holidayList
    //            }
    //        }
    //
    //        let parseOperation = BlockOperation {
    //            NSLog("Service - Full - Done")
    //            let reponse = ModelResponse(breweryList: breweries, holidayList: holidays)
    //            // MARK: GAMBIARRA PRA FUNCIONAR NA MAIN THREAD
    //            OperationQueue.main.addOperation {
    //                completion(.success(reponse))
    //            }
    //        }
    //
    //        parseOperation.addDependency(opBrew)
    //        parseOperation.addDependency(opHoliday)
    //
    //        operationQueue.addOperations([opBrew, opHoliday, parseOperation], waitUntilFinished: false)
    //    }
}
