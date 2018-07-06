//
//  MockURLSession.swift
//  MagiSkyTests
//
//  Created by 安然 on 2018/7/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation
@testable import MagiSky

class MockURLSession: URLSessionProtocol {
    
    var sessionDataTask = MockURLSessionDataTask()
    var responseData: Data?
    var responseHeader: HTTPURLResponse?
    var responseError: Error?
    /// 测试的时候将异步改为同步
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping URLSessionProtocol.DataTaskHandler)
        -> URLSessionDataTaskProtocol {
            completionHandler(responseData, responseHeader, responseError)
            return sessionDataTask
    }
    
}
