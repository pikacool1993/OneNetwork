//
//  Loan2.swift
//  OneNetwork_Example
//
//  Created by OneLei on 2020/7/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

class Loan2: HandyJSON {
    
    var name: String!
    var use: String!
    var loan_amount: Int = 0
    
    required init() {}
}

class LoanDataStore2: HandyJSON {
    
    var loans: [Loan2]?
    
    required init() {}
}
