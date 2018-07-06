//
//  WeatherDataManager.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/5.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation

enum DataManagerError: Error {
    case failedRequest
    case invalidResponse
    case unknow
}

internal class DarkSkyURLSession: URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping URLSessionProtocol.DataTaskHandler)
        -> URLSessionDataTaskProtocol {
            return DarkSkyURLSessionDataTask(
                request: request,
                completion: completionHandler)
    }
}

internal class DarkSkyURLSessionDataTask: URLSessionDataTaskProtocol {
    private let request: URLRequest
    private let completion: URLSessionProtocol.DataTaskHandler
    
    init(request: URLRequest, completion: @escaping URLSessionProtocol.DataTaskHandler) {
        self.request = request
        self.completion = completion
    }

    // 调用这个方法等于是调用网络请求
    func resume() {
        // 添加测试环境的数据配置
        let json = ProcessInfo
            .processInfo
            .environment["FakeJSON"]

        if let json = json {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)
            let data = json.data(using: .utf8)!

            completion(data, response, nil)
        }
    }
}

internal struct Config {
    private static func isUITesting() -> Bool {
        return ProcessInfo.processInfo.arguments.contains("UI-TESTING")
    }
    
    static var urlSession: URLSessionProtocol = {
        if isUITesting() {
            return DarkSkyURLSession()
        }
        else {
            return URLSession.shared
        }
    }()
}

final class WeatherDataManager {
    
    internal let baseUrl: URL
    
    internal let urlSession: URLSessionProtocol
    
    init(_ baseUrl: URL, urlSession: URLSessionProtocol) {
        self.baseUrl = baseUrl
        self.urlSession = urlSession
    }
    
    static let shared = WeatherDataManager(API.authenticatedUrl,
                                           urlSession: Config.urlSession)
    
    typealias CompletionHandler = (WeatherData?, DataManagerError?)->Void
    
    func weatherDataAt(latitude: Double, longitude: Double, completion: @escaping CompletionHandler)  {
        let url = baseUrl.appendingPathComponent("\(latitude),\(longitude)")
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "GET"
        
        self.urlSession.dataTask(with: request) {
            (data, response, error) in
            self.didFinishGettingWeatherData(data: data,
                                             response: response,
                                             error: error,
                                             completion: completion)
            
            }.resume()
        
    }
    
    private func didFinishGettingWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler) {
        if let _ = error {
            completion(nil, .failedRequest)
        }
        
        else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(weatherData, nil)
                }
                
                catch {
                    completion(nil, .invalidResponse)
                }
            }
            
            else {
                completion(nil, .failedRequest)
            }
        }
        
        else {
            completion(nil, .unknow)
        }
    }
    
}
