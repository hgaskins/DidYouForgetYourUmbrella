//
//  OpenWeatherTestingTests.swift
//  OpenWeatherTestingTests
//
//  Created by hannah gaskins on 9/23/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import UIKit
import XCTest
@testable import OpenWeatherTesting


class OpenWeatherTestingTests: XCTestCase {
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        
        // found code for "unrulely" viewController instantiation and it turned out to work!
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: NSBundle.mainBundle())
        viewController = storyboard.instantiateInitialViewController() as! ViewController
        
        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
      
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Network Testing - Async
    
    func testOpenWeatherMapNetworkingCall() {
        
        let wc = WeatherClient(delegate: viewController)
        
        let city = "Miami"
        
        let baseURLOpenWeatherMap = "http://api.openweathermap.org/data/2.5/weather"
        let APIKeyOpenWeatherMap = "9cc1097e246f4f507d2c0cd83c5afdbb"
        
        let expectation = expectationWithDescription("vc does stuff and runs callback closures")
        
        let asyncCallback = {() in
            
            XCTAssertNotNil(self.viewController.cityLabel!.text)
            XCTAssertNotNil(self.viewController.weatherLabel!.text)
            XCTAssertNotNil(self.viewController.tempLabel!.text)
            XCTAssertNotNil(self.viewController.cloudCoverLabel.text)
            XCTAssertNotNil(self.viewController.humidityLabel.text)
            
            expectation.fulfill()
        }
        
        wc.getCityWeather(NSURL(string: "\(baseURLOpenWeatherMap)?APPID=\(APIKeyOpenWeatherMap)&q=\(city)")!, asyncCallback)
        
        waitForExpectationsWithTimeout(5) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testOpenWeatherMapBadData() {
        
        let wc = WeatherClient(delegate: viewController)
        
        let city = ""
        
        let baseURLOpenWeatherMap = "http://api.openweathermap.org/data/2.5/weather"
        let APIKeyOpenWeatherMap = "9cc1097e246f4f507d2c0cd83c5afdbb"
        
        let expectation = expectationWithDescription("vc does stuff and runs callback closures")
        
        let asyncCallback = {() in
            
            XCTAssertNotNil(self.viewController.cityLabel!.text)
            XCTAssertNotNil(self.viewController.weatherLabel!.text)
            XCTAssertNotNil(self.viewController.tempLabel!.text)
            XCTAssertNotNil(self.viewController.cloudCoverLabel.text)
            XCTAssertNotNil(self.viewController.humidityLabel.text)
            
            expectation.fulfill()
        }
        
        wc.getCityWeather(NSURL(string: "\(baseURLOpenWeatherMap)?APPID=\(APIKeyOpenWeatherMap)&q=\(city)")!, asyncCallback)
        
        
        waitForExpectationsWithTimeout(5) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    
    // Model Testing - weather struct
    
    func testDataValidity() {
        
        let wc = WeatherClient(delegate: viewController)
        
        let city = "Minneapolis"
        
        let baseURLOpenWeatherMap = "http://api.openweathermap.org/data/2.5/weather"
        let APIKeyOpenWeatherMap = "9cc1097e246f4f507d2c0cd83c5afdbb"
        
        let expectation = expectationWithDescription("vc does stuff and runs callback closures")
        
        let asyncCallback = {() in
            
            XCTAssertEqual(wc.weather!.longitude, -93.260000000000005)
            XCTAssertEqual(wc.weather!.latitude, 44.979999999999997)
            
            expectation.fulfill()
        }
        
        wc.getCityWeather(NSURL(string: "\(baseURLOpenWeatherMap)?APPID=\(APIKeyOpenWeatherMap)&q=\(city)")!, asyncCallback)
        
        waitForExpectationsWithTimeout(5) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    // CoreLocation Testing
    
    func testCLLocationManager() {
    
        let lm = viewController.locationManager
        
        XCTAssertEqual(lm.desiredAccuracy, 3000.0)
        XCTAssertNotNil(lm.delegate)
        XCTAssertNotNil(viewController.accessLocation())
    }
}
