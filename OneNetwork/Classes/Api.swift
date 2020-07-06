//
//  File.swift
//  OneNetwork_Example
//
//  Created by OneLei on 2020/6/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON

public enum NetworkError: Error, LocalizedError, CustomNSError {
    case jsonParsingError
    case responseDataFormatError
    
    public var errorDescription: String? {
        switch self {
        case .jsonParsingError:
            return ""
        case .responseDataFormatError:
            return ""
        }
    }
    
    public var errorCode: Int {
        switch self {
        case .jsonParsingError:
            return 2001
        case .responseDataFormatError:
            return 2002
        }
    }
}

class Api: NSObject {
    
    var method = HTTPMethod.get
    
    var path: String {
        return ""
    }
    
    var url: String {
        return NetworkConfig.environment.host + path
    }
    
    var parameters = [String : Any]()
    var headers = HTTPHeaders()
    
    public var needCache = false
    
    public var success: (Any) -> Void = { _ in }
    public var fail: (NSError) -> Void = { _ in }
    
    public init(httpMethod: HTTPMethod = .get) {
        super.init()
        method = httpMethod
        configHeaders()
    }
    
    private func configHeaders() {
        
    }
    
    func prepareForRequest() {
        
    }
    
    public func request<T: HandyJSON>() -> NetworkRequest<T> {
        func parasingJson(json: Any) -> T? {
            guard let result = json as? [String: Any] else {
                return nil
            }
            
            if let model = T.deserialize(from: result) {
                return model;
            }
            
            return nil
        }
        
        let handler = NetworkRequest<T>() { [weak self] (success, fail) in
            guard let strongSelf = self else { return }
            strongSelf.configRequest(failed: fail, success: { (data: [String: Any]) in
                if let models = parasingJson(json: data) {
                    success(models)
                    strongSelf.success(models)
                } else {
                    fail(NetworkError.jsonParsingError as NSError)
                    strongSelf.fail(NetworkError.jsonParsingError as NSError)
                }
            })
        }
        return handler
    }
    
    private func configRequest<T>(failed: @escaping (NSError) -> Void, success: @escaping (T) -> Void) {
        prepareForRequest()
        
        let request = AF.request(url, method: method, parameters: parameters, headers: headers)
        request.responseJSON { response in
            guard let statusCode = response.response?.statusCode else {
                let error = NSError(domain: self.url, code: -1, userInfo: ["description":"status code null"])
                self.fail(error)
                failed(error)
                return
            }
            
            if let error = response.error {
                self.fail(error as NSError)
                failed(error as NSError)
                return
            }
            
            switch statusCode {
            case 200...299:
                guard let data = response.data else {
                    failed(NetworkError.responseDataFormatError as NSError)
                    self.fail(NetworkError.responseDataFormatError as NSError)
                    return
                }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? T else {
                        failed(NetworkError.responseDataFormatError as NSError)
                        self.fail(NetworkError.responseDataFormatError as NSError)
                        return
                    }

                    if self.needCache {

                    }
                    success(json)
                } catch {
                    failed(NetworkError.responseDataFormatError as NSError)
                    self.fail(NetworkError.responseDataFormatError as NSError)
                }
                
            default:
                guard let data = response.data else {
                    failed(NetworkError.responseDataFormatError as NSError)
                    self.fail(NetworkError.responseDataFormatError as NSError)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                        let error = NSError(domain: self.url, code: statusCode, userInfo: json)
                        self.fail(error as NSError)
                        failed(error as NSError)
                    } else {
                        let error = NSError(domain: self.url, code: statusCode, userInfo: ["description":"data null"])
                        self.fail(error as NSError)
                        failed(error as NSError)
                    }
                } catch {
                    failed(NetworkError.responseDataFormatError as NSError)
                    self.fail(NetworkError.responseDataFormatError as NSError)
                }
            }
        }
        
    }
    
}
