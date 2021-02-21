//
//  ApiResponse.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 12/02/21.
//

import Foundation

// Encodable -> Mock Json

struct Brewery : Codable {
    var id:Int?
    var name:String?
    var street:String?
    var brewery_type:String?
    var city:String?
    var state:String?
    var postal_code:String?
    var country:String?
    var longitude:String?
    var latitude:String?
    var phone:String?
}

struct Holiday: Codable {
    var date:String?
    var name:String?
    var global:Bool=false
}

struct ModelResponse {
    let breweryList: [Brewery]
    let holidayList: [Holiday]
}

enum NetworkError : Error {
    case serverError
    case other
    
    static func from(nserror: NSError) -> Self {
        if nserror.code == 500 {
            return NetworkError.serverError
        } else {
            return NetworkError.other
        }
    }
}
