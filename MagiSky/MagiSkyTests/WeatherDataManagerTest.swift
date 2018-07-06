//
//  WeatherDataManagerTest.swift
//  MagiSkyTests
//
//  Created by 安然 on 2018/7/5.
//  Copyright © 2018年 anran. All rights reserved.
//

import XCTest
@testable import MagiSky

class WeatherDataManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// 测试用例
    func test_weatherDataAt_starts_the_session() {
        let session = MockURLSession()
        let dataTask = MockURLSessionDataTask()
        session.sessionDataTask = dataTask
        let url = URL(string: "https://darksky.net")!
        let manager = WeatherDataManager(url, urlSession: session)
        
        manager.WeatherDataAt(latitude: 100,
                              longitude: 100) { (_, _) in}
        XCTAssert(session.sessionDataTask.isResumeCalled, "没有调用resume方法")
    }
    
}
