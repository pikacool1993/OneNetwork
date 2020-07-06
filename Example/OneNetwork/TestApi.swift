//
//  TestApi.swift
//  OneNetwork_Example
//
//  Created by OneLei on 2020/6/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

class TestApi: Api {
    override var path: String {
        return "/v1/loans/newest.json"
    }
    
//    public lazy var handler: NetworkRequest<LoanDataStore> = self.request()
//    
//    public func start() {
//        handler.start()
//    }
}
