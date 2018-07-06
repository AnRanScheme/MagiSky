//
//  CurrentWeatherUITests.swift
//  MagiSkyUITests
//
//  Created by 安然 on 2018/7/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import XCTest

class CurrentWeatherUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        // 测试失败之后会不会继续执行
        continueAfterFailure = false
        app.launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// UI单元测试与网络相关太严重,失败了好几次
    func test_location_button_exists() {
        
        let locationBtn = app.buttons["LocationBtn"]
        
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: locationBtn, handler: nil)
        
        waitForExpectations(timeout: 20, handler: nil)
        /*
         在这里打断点之后可以在lldb里面获取UI信息
         po app.images 获取图片
         po app.buttons 获取按钮
         po app.staticTexts 获取UILabel
         */
        XCTAssert(locationBtn.exists)
        
    }

    
}
