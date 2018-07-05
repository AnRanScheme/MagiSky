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

final class WeatherDataManager {
    
    private let baseUrl: URL
    
    init(_ baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    static let shared = WeatherDataManager(API.authenticatedUrl)
    
    typealias CompletionHandler = (WeatherData?, DataManagerError?)->Void
    
    func WeatherDataAt(latitude: Double, longitude: Double, completion: @escaping CompletionHandler)  {
        let url = baseUrl.appendingPathComponent("\(latitude),\(longitude)")
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            DispatchQueue.main.async {
                self.didFinishGettingWeatherData(data: data,
                                                 response: response,
                                                 error: error,
                                                 completion: completion)
            }
        }
        
    }
    
    func didFinishGettingWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler) {
        if let _ = error {
            completion(nil, .failedRequest)
        }
        
        else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
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
