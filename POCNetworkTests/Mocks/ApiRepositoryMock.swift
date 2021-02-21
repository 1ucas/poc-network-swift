//
//  ApiRepositoryMock.swift
//  POCNetworkTests
//
//  Created by Lucas Ramos Maciel on 18/02/21.
//

import Foundation

@testable import POCNetwork

enum ApiRepositoryMockState {
    case apiError
    case emptyList
    case sucessOne
    case sucessTwo
}

class ApiRepositoryMock: ApiRepositoryProtocol {
    
    private let brewState: ApiRepositoryMockState
    private let holidayState: ApiRepositoryMockState
    
    public init(mockStateBrew: ApiRepositoryMockState, mockStateHoliday: ApiRepositoryMockState) {
        brewState = mockStateBrew
        holidayState = mockStateHoliday
    }
    
    func listBreweries(page: Int, completion: FetchBreweryCompletion) {
        switch brewState {
        case .apiError, nil:
            completion(.failure(NSError(domain: "Network", code: 500, userInfo: nil)))
        case .emptyList:
            completion(.success([]))
        case .sucessOne:
            completion(.success([ApiClient.mockBrewList.first!]))
        case .sucessTwo:
            completion(.success(ApiClient.mockBrewList))
        }
    }
    
    func listHolidays(completion: @escaping FetchHolidaysCompletion) {
        switch holidayState {
        case .apiError:
            completion(.failure(NSError(domain: "Network", code: 500, userInfo: nil)))
        case .emptyList:
            completion(.success([]))
        case .sucessOne:
            completion(.success([ApiClient.mockHolidayList.first!]))
        case .sucessTwo:
            completion(.success(ApiClient.mockHolidayList))
        }
    }
}
