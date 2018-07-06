//
//  MockURLSessionDataTask.swift
//  MagiSkyTests
//
//  Created by 安然 on 2018/7/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation
import XCTest
@testable import MagiSky

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    private (set) var isResumeCalled = false
    
    func resume() {
        self.isResumeCalled = true
    }
}
