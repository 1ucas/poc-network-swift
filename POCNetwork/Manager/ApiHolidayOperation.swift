//
//  ApiHolidayOperation.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 21/02/21.
//

import Foundation

class ApiHolidayOperation: AsynchronousOperation {
    
    private let apiProvider: ApiClient
    private let completion: FetchHolidaysCompletion
        
    init(apiClient: ApiClient? = nil, completion: @escaping FetchHolidaysCompletion) {
        self.apiProvider = apiClient ?? ApiClient()
        self.completion = completion
    }
    
    override func main() {
        apiProvider.listHolidays { [self] response in
            NSLog("Operation - Holiday - Done")
            
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
