//
//  Completions.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 21/02/21.
//

import Foundation

typealias FetchBreweryCompletion = (Result<[Brewery], Error>) -> Void
typealias FetchHolidaysCompletion = (Result<[Holiday], Error>) -> Void
typealias FetchFullListCompletion = (Result<ModelResponse, NetworkError>) -> Void

