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
    
    internal let baseUrl: URL
    
    internal let urlSession: URLSessionProtocol
    
    init(_ baseUrl: URL, urlSession: URLSessionProtocol) {
        self.baseUrl = baseUrl
        self.urlSession = urlSession
    }
    
    static let shared = WeatherDataManager(API.authenticatedUrl, urlSession: URLSession.shared)
    
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
