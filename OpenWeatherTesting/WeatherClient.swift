//
//  WeatherClient.swift
//  OpenWeatherTesting
//
//  Created by hannah gaskins on 9/23/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import Foundation

protocol WeatherClientDelegate : class {
    func didGetWeatherData(weather: Weather)
    func didNotGetWeatherData(error: NSError)
}

class WeatherClient {
    
    let baseURLOpenWeatherMap = "http://api.openweathermap.org/data/2.5/weather"
    
    // TODO: store in keychin? gitignore won't work here and oauth out of scope of the project
    let APIKeyOpenWeatherMap = "9cc1097e246f4f507d2c0cd83c5afdbb"
    
    var weather: Weather?
    
    var delegate: WeatherClientDelegate
    
    init(delegate: WeatherClientDelegate) {
        
        self.delegate = delegate
    }
    
    func openWeatherMapDataByCoordinates(latitude latitude: Double, longitude: Double) {
        
        let requestURL = NSURL(string: "\(baseURLOpenWeatherMap)?APPID=\(APIKeyOpenWeatherMap)&lat=\(latitude)&lon=\(longitude)")!
        getCityWeather(requestURL, nil)
    }
    
    func getCityWeather(requestURL: NSURL, _ completeCallback: (() -> Void)?) {
        
        let session = NSURLSession.sharedSession()
        session.configuration.timeoutIntervalForRequest = 3
        
        let task = session.dataTaskWithURL(requestURL) {
            
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let networkError = error {
                
                self.delegate.didNotGetWeatherData(networkError)
            } else {
                do {
                    let weatherData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject]
                    
                    self.weather = Weather(weatherData: weatherData)
                    self.delegate.didGetWeatherData(self.weather!)
                    
                    if(completeCallback != nil) {
                        completeCallback!()
                    }
                }
                    
                catch let jsonError as NSError {
                    self.delegate.didNotGetWeatherData(jsonError)
                }
            }
        }
        // all above code DEFINES the data task. This resume() method activates it
        task.resume()
    }
}