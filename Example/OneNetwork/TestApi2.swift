//
//  TestApi2.swift
//  OneNetwork_Example
//
//  Created by OneLei on 2020/7/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

class TestApi2: Api {
    override var path: String {
        return "/v1/loans/newest.json"
    }
    
    public lazy var handler: NetworkRequest<LoanDataStore2> = self.request()

    public func start() {
        handler.start()
    }
}
