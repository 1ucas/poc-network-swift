//
//  ApiServiceMock.swift
//  POCNetworkTests
//
//  Created by Lucas Ramos Maciel on 03/03/21.
//

import Foundation

@testable import POCNetwork

class ApiServiceMock: ApiServiceProtocol {
    
    func listBreweries(page: Int, completion: @escaping FetchBreweryCompletion) {
        completion(.success(ApiClient.mockBrewList))
    }
    
}
