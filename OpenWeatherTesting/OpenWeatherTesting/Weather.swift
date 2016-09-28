//
//  Weather.swift
//  OpenWeatherTesting
//
//  Created by hannah gaskins on 9/24/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//


// to more easily send the weather data from WeatherClient to the VC, we create a struct for Weather. When initializing the Weather struct, we pass it the [String: AnyObject] dictionary created by parsing JSON from OpenWeatherMap. Weather then takes that data from that dictionary and uses it to initialize its properites. 

// the Weather struct turns the dictionary or dictionaries structure of the data from OpenWeatherMap into a flat set of weather properties

// it computes the temp from K to F 


import UIKit

public struct Weather {
    let city: String //
    let longitude: Double //
    let latitude: Double //
    let weatherID: Int //
    let mainWeather: String //
    let weatherDescription: String //
    let temp: Double //
    // openweathermap provides temp in Kelvin
    var tempFahrenheit: Double {
        get {
            return (temp - 273.15) * 1.8 + 32
        }
    }
    let humidity: Int //
    let cloudCover: Int //
    let rainFallInLast3Hours: Double?
    
    init(weatherData: [String : AnyObject]) {
        city = weatherData["name"] as! String
        
        let coordDict = weatherData["coord"] as! [String : AnyObject]
        longitude = coordDict["lon"] as! Double
        latitude = coordDict["lat"] as! Double
        
        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
        weatherID = weatherDict["id"] as! Int
        weatherDescription = weatherDict["description"] as! String
        mainWeather = weatherDict["main"] as! String
        
        let mainDict = weatherData["main"] as! [String : AnyObject]
        temp = mainDict["temp"] as! Double
        humidity = mainDict["humidity"] as! Int
        
        cloudCover = weatherData["clouds"]!["all"] as! Int
        
        if weatherData["rain"] != nil {
            let rainDict = weatherData["rain"] as! [String : AnyObject]
            rainFallInLast3Hours = rainDict["3h"] as? Double
        } else {
            rainFallInLast3Hours = nil
        }
    }
    
}