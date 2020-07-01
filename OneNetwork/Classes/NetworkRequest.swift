//
//  NetworkRequest.swift
//  OneNetwork_Example
//
//  Created by OneLei on 2020/6/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

protocol RequestInvokable {
    func start()
    func excuteFailedAction(error: NSError)
}

public class NetworkRequest<T>: NSObject, RequestInvokable {
    
    typealias SuccessClosure = (T) -> Void
    typealias FailClosure = (NSError) -> Void
    
    private var success: SuccessClosure = { _ in }
    private var fail: FailClosure = { _ in }
    private var startAction: (@escaping SuccessClosure, @escaping FailClosure) -> Void
    
    var parsingJson: (Any) -> T? = { _ in return nil }
    
    init(start: @escaping (@escaping SuccessClosure, @escaping FailClosure) -> Void) {
        startAction = start
        super.init()
    }
    
    public func start() {
        startAction(success, fail)
    }
    
    func excuteFailedAction(error: NSError) {
        fail(error)
    }
    
    @discardableResult
    public func succeed(handler: @escaping (T) -> Void) -> NetworkRequest<T> {
        success = { response in
            handler(response)
        }
        return self
    }
    
    @discardableResult
    public func failed(handler: @escaping (NSError) -> Void) -> NetworkRequest<T> {
        fail = handler
        return self
    }
}
