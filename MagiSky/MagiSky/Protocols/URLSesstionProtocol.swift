//
//  URLSesstionProtocol.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation

/// 用于单元测试  Mock 方法
protocol URLSessionProtocol {
    
    typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskHandler)
        -> URLSessionDataTaskProtocol
}
