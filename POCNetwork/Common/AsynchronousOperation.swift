//
//  AsyncOperation.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 01/03/21.
//  From: https://gist.github.com/CanTheAlmighty/fabdef60994171859a90acfc43b9d1d0
//

import Foundation

open class AsynchronousOperation: Operation
{
    public enum State : String
    {
        case ready     = "Ready"
        case executing = "Executing"
        case finished  = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    override open var isAsynchronous : Bool { return true }
    override open var isExecuting    : Bool { return state == .executing }
    override open var isFinished     : Bool { return state == .finished }
    
    public private(set) var state = State.ready
    {
        willSet(n)
        {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: n.keyPath)
        }
        didSet(o)
        {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: o.keyPath)
        }
    }
        
    override open func start()
    {
        if self.isCancelled
        {
            state = .finished
        }
        else
        {
            state = .ready
            main()
        }
    }
        
    public func finish()
    {
        guard state != .finished else { return }
        
        state = .finished
    }
}

open class AsynchronousBlockOperation : AsynchronousOperation {
    
    private let block: (@escaping ()->Void) -> Void
    
    init(_ block: @escaping (@escaping ()->Void) -> Void) {
        self.block = block
    }
    
    override open func main() {
        block(finish)
    }
    
}
