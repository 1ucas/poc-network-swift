//
//  ViewModel.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 03/03/21.
//

import Foundation

class ViewModelDireto {
    
    private let apiService: ApiServiceProtocol
    
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    public func listBreweries(page:Int, completion: @escaping FetchBreweryCompletion) {
        apiService.listBreweries(page: page) { response in
            completion(response)
        }
    }
}

class ViewModelOperation {
    
    private let apiManager: ApiManager
    
    init(apiManager:ApiManager = ApiManager()) {
        self.apiManager = apiManager
    }
    
    public func listBreweries(page:Int, completion: @escaping FetchBreweryCompletion) {
        apiManager.listBreweries(page: page) { response in
            completion(response)
        }
    }
}

