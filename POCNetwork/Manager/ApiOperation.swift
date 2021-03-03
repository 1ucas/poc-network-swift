//
//  ApiOperation.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 12/02/21.
//

import Foundation






class ApiOperation: AsynchronousOperation {
    
    private let page:Int
    private let apiProvider: ApiClient
    private let completion: FetchBreweryCompletion
        
    init(page: Int, apiClient: ApiClient? = nil, completion: @escaping FetchBreweryCompletion) {
        self.page = page
        self.apiProvider = apiClient ?? ApiClient()
        self.completion = completion
    }
    
    override func main() {
        apiProvider.listBreweries(withPage: page) { [self] response in
            NSLog("Operation - Brew - Done")
            do {
                let result = try response()
                self.completion(.success(result))
            } catch {
                self.completion(.failure(error))
            }
            finish()
        }
    }
    
}
