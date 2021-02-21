//
//  ApiRepository.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 12/02/21.
//

import Foundation

protocol ApiRepositoryProtocol {
    func listBreweries(page: Int, completion: @escaping FetchBreweryCompletion)
    func listHolidays(completion: @escaping FetchHolidaysCompletion)
}

class ApiRepository: ApiRepositoryProtocol {
    
    private let apiClient : ApiClient
    
    init(apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
    }
    
    func listBreweries(page: Int, completion: @escaping FetchBreweryCompletion) {
        self.apiClient.listBreweries(withPage: page) { response in
            NSLog("Repository - Brew - Done")
            
            do {
                let result = try response()
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func listHolidays(completion: @escaping FetchHolidaysCompletion){
        apiClient.listHolidays { response in
            NSLog("Repository - Holiday - Done")

            do {
                let result = try response()
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
