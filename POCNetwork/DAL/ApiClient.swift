//
//  ApiClient.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 12/02/21.
//

import Foundation

public enum EnvEnum {
    case test
    case testError
    case run
}

open class Ambiente {
    static var BASE_URL_BREW = AmbientesApi.PROD_BREW.rawValue
    static var BASE_URL_HOLIDAY = AmbientesApi.PROD_HOLIDAY.rawValue
}

public enum AmbientesApi : String {
    case TESTES = "http://localhost:8080"
    case PROD_BREW = "https://api.openbrewerydb.org"
    case PROD_HOLIDAY = "https://date.nager.at/PublicHoliday"
}


typealias NetworkCompletion<T> = (() throws -> T) -> Void


// TODO: IGNORAR POR FAVOR A ESTRUTURA DESSE API CLIENT! ISSO EH UMA POC.
// Não faz sentido separar cada uma das chamadas

public struct ApiClient {
    
    private static var sessionConfig:URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        return config
    }
    
    private static let session = URLSession.init(configuration: ApiClient.sessionConfig)
    
    private let env: EnvEnum
    
    init(env: EnvEnum = .run) {
        self.env = env
    }
    
    func listBreweries(withPage page: Int, completion: @escaping NetworkCompletion<[Brewery]>) {
        if env == .test {
            completion { return ApiClient.mockBrewList }
        } else if env == .testError {
            completion { throw NSError(domain: "Test Error", code: 500, userInfo: nil) }
        }
        
        let request = URLRequest(url: URL(string: "\(Ambiente.BASE_URL_BREW)/breweries?per_page=20&page=\(page)")!)

        makeRequest(request: request, completion: completion)
    }
    
    func listHolidays(completion: @escaping NetworkCompletion<[Holiday]>) {
        if env == .test {
            completion { return ApiClient.mockHolidayList }
        } else if env == .testError {
            completion { throw NSError(domain: "Test Error", code: 500, userInfo: nil) }
        }
        
        let request = URLRequest(url: URL(string: "\(Ambiente.BASE_URL_HOLIDAY)/Country/US")!)

        makeRequest(request: request, completion: completion)
    }
    
    func makeRequest<T:Decodable>(request: URLRequest, completion: @escaping NetworkCompletion<T>) {
        ApiClient.session.dataTask(with: request) { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONDecoder().decode(T.self, from: data!)
                completion { return json }
            } catch {
                NSLog("error")
                completion { throw error }
            }
        }.resume()
    }
    
    static let mockBrewList: [Brewery] = [
        Brewery(id: 1, name: "Cervejaria1", street: "Rua1", brewery_type: "1", city: "BH", state: "MG", postal_code: "31160290", country: "BR", longitude: "100", latitude: "100", phone: "(31)988990000"),
        Brewery(id: 2, name: "Cervejaria2", street: "Rua2", brewery_type: "2", city: "BH", state: "MG", postal_code: "31160290", country: "BR", longitude: "200", latitude: "200", phone: "(31)988990001")
    ]
    
    static let mockHolidayList: [Holiday] = [
        Holiday(date: "01/01/2021", name: "Feriado1", global: true),
        Holiday(date: "05/05/2021", name: "Feriado2", global: false)
    ]
}
