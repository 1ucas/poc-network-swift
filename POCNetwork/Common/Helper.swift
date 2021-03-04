//
//  Helper.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 03/03/21.
//

import Foundation
import os.log

func unwrapResult<T>(input: Result<T,Error>) -> T? {
    switch input {
    case .success(let item):
        return item
    case .failure(_):
        return nil
    }
}

class InstrumentsManagerLogger : OperationQueue {
        
    private static let pointsOfInterest = OSLog(subsystem: "ServicePOI", category: .pointsOfInterest)
    private let id = OSSignpostID(log: InstrumentsManagerLogger.pointsOfInterest)
    
    func startLog() {
        os_signpost(.begin, log: InstrumentsManagerLogger.pointsOfInterest, name: "OPE CALL", signpostID: id)
    }
    
    func endLog() {
        os_signpost(.end, log: InstrumentsManagerLogger.pointsOfInterest, name: "OPE CALL", signpostID: self.id)
    }
}

class InstrumentsServiceLogger {
        
    private static let pointsOfInterest = OSLog(subsystem: "ServicePOI", category: .pointsOfInterest)
    private let id = OSSignpostID(log: InstrumentsServiceLogger.pointsOfInterest)
    
    func startLog() {
        os_signpost(.begin, log: InstrumentsServiceLogger.pointsOfInterest, name: "REPO CALL", signpostID: id)
    }
    
    func endLog() {
        os_signpost(.end, log: InstrumentsServiceLogger.pointsOfInterest, name: "REPO CALL", signpostID: self.id)
    }
}

