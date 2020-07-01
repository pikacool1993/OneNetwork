//
//  NetworkEnvironment.swift
//  OneNetwork_Example
//
//  Created by OneLei on 2020/6/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public enum NetworkEnvironment {
    case debug
    case release
    
    var host: String {
        switch self {
        case .debug:
            return "http://api.kivaws.org"
        case .release:
            return "http://api.kivaws.org"
        }
    }
    
}
