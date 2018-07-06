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
    
    let url = URL(string: "https://darksky.net")!
    var session: MockURLSession!
    var manager: WeatherDataManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.session = MockURLSession()
        self.manager = WeatherDataManager(url, urlSession: session)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// 测试用例
    func test_weatherDataAt_starts_the_session() {
        let dataTask = MockURLSessionDataTask()
        session.sessionDataTask = dataTask
        let url = URL(string: "https://darksky.net")!
        let manager = WeatherDataManager(url, urlSession: session)
        
        manager.weatherDataAt(latitude: 52,
                              longitude: 100) { (_, _) in}
        XCTAssert(session.sessionDataTask.isResumeCalled, "没有调用resume方法")
    }
    
    /// 网络获取数据为异步
    /*
     首先，测试结果仍旧取决于网络状况，因此我们很难保证多次测试结果的一致性；
     其次，当我们要测试一个REST服务的时候，
     如果每个URL的测试都基于实际网络访问和超时的机制，将会显著增加测试执行的时间；
     为此，我们需要需要第二种方法：
     把从网络获取到数据的部分mock出来，并且，让异步执行的代码同步执行，这样才可以精确管理测试用例的执行过程。
     */
    func test_weatherDataAt_getData() {
        var data: WeatherData?
        /// 其中的一种解决方法 期望
        let expect = expectation(description: "加载数据 \(API.authenticatedUrl)")
        WeatherDataManager.shared.weatherDataAt(latitude: 52, longitude: 100) { (response, error) in
            data = response
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(data, "数据为空")
    }
    
    func test_weatherDataAt_handle_invalid_request() {
        session.responseError = NSError(
            domain: "Invalid Request", code: 100, userInfo: nil)
        var error: DataManagerError? = nil
        
        manager.weatherDataAt(latitude: 52, longitude: 100, completion: {
            (_, e) in
            error = e
        })
        
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    /// 测试参数错误是否
    func test_weatherDataAt_handle_statuscode_not_equal_to_200() {
        session.responseHeader = HTTPURLResponse(
            url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let data = "{}".data(using: .utf8)!
        session.responseData = data
        
        var error: DataManagerError? = nil
        
        manager.weatherDataAt(latitude: 52, longitude: 100, completion: {
            (_, e) in
            error = e
        })
        
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    /// 测试网络失败
    func test_weatherDataAt_handle_invalid_response() {
        session.responseHeader = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        
        let data = "{".data(using: .utf8)!
        session.responseData = data
        
        var error: DataManagerError? = nil
        
        manager.weatherDataAt(
            latitude: 52,
            longitude: 100,
            completion: {
                (_, e) in
                error = e
        })
        
        XCTAssertEqual(error, DataManagerError.invalidResponse)
    }
    
    /// 测试解码是否正确
    func test_weatherDataAt_handle_response_decode() {
        session.responseHeader = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        
        let data = """
    {
        "longitude" : 100,
        "latitude" : 52,
        "currently" : {
            "temperature" : 23,
            "humidity" : 0.91,
            "icon" : "snow",
            "time" : 1507180335,
            "summary" : "Light Snow"
        }
    }
    """.data(using: .utf8)!
        session.responseData = data
        
        var decoded: WeatherData? = nil
        
        manager.weatherDataAt(
            latitude: 52,
            longitude: 100,
            completion: {
                (d, _) in
                decoded = d
        })
        
        let expected = WeatherData(
            latitude: 52,
            longitude: 100,
            currently: WeatherData.CurrentWeather(
                time: Date(timeIntervalSince1970: 1507180335),
                summary: "Light Snow",
                icon: "snow",
                temperature: 23,
                humidity: 0.91))
        
        XCTAssertEqual(decoded, expected)
    }
    
}
