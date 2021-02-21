//
//  ApiMockServer.swift
//  POCNetworkTests
//
//  Created by Lucas Ramos Maciel on 21/02/21.
//

import Swifter
@testable import POCNetwork

class ApiMockServer {
    
    private static let server: HttpServer = HttpServer()
    private static var initialized = false
    
    static func registerResponse<T: Codable>(route: String, object: T) {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(object)
            let dataString = String(data: data, encoding: .utf8)
            server[route] = { _ in .ok(.text(dataString!))  }
        } catch {
            fatalError("Cannot encode Mock Object")
        }
    }
    
    static func start() {
        guard !initialized else { return }

        Ambiente.BASE_URL_BREW = AmbientesApi.TESTES.rawValue
        Ambiente.BASE_URL_HOLIDAY = AmbientesApi.TESTES.rawValue

        do {
            try server.start()
            initialized = true
        } catch {
            fatalError("Mock Server not Initialized")
        }
    }
    
    static func stop() {
        guard initialized else { return }
        
        server.stop()
        
        initialized = false
    }
}
