//
//  ViewController.swift
//  OpenWeatherTesting
//
//  Created by hannah gaskins on 9/23/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController:   UIViewController,
                        WeatherClientDelegate,
                        CLLocationManagerDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var rainInLastThreeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var getLocationWeatherButton: UIButton!
    
    let locationManager: CLLocationManager = CLLocationManager()
    var weather: WeatherClient!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        weather = WeatherClient(delegate: self)
        
        // initializing UI
        cityLabel.text = "city sample"
        weatherLabel.text = ""
        tempLabel.text = ""
        cloudCoverLabel.text = ""
        rainInLastThreeLabel.text = ""
        humidityLabel.text = ""
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        accessLocation()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    // button events and states
    
    @IBAction func getWeatherByLocationButtonPressed(sender: UIButton) {
        
        setWeatherButtonStates(false)
        accessLocation()
        
    }
    
    func setWeatherButtonStates(state: Bool) {
        
        getLocationWeatherButton.enabled = state
    }
    
    // weatherclient methods
    
    func didGetWeatherData(weather: Weather) {

        dispatch_async(dispatch_get_main_queue()) {
            
            self.cityLabel.text = weather.city
            self.weatherLabel.text = weather.weatherDescription
            self.tempLabel.text = "tempInF: \(Int(round(weather.tempFahrenheit)))F"
            self.cloudCoverLabel.text = "cloudCover: \(weather.cloudCover)%"
            self.humidityLabel.text = "humidity: \(weather.humidity)%"
            
            if let rain = weather.rainFallInLast3Hours {
                self.rainInLastThreeLabel.text = "rainInLast3Hours: \(rain) mm ☔️"
            } else {
                self.rainInLastThreeLabel.text = "rainInLast3Hours: None 😎"
            }
            self.getLocationWeatherButton.enabled = true
        }
    }
    
    func didNotGetWeatherData(error: NSError) {
        
        dispatch_async(dispatch_get_main_queue()) {
            print("error:\(error.description)")
        }
    }
    
    // CLLocation methods
    
    func accessLocation() {
        
        guard CLLocationManager.locationServicesEnabled() else {
            print("error accessing location")
            getLocationWeatherButton.enabled = true
            return
        }
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        guard authorizationStatus == .AuthorizedWhenInUse else {
    
            switch authorizationStatus {
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                print("")
            }
            
            print("error authorization location services")
            return
        }
        
        // locaitonManager delegate stuff & things
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        weather.openWeatherMapDataByCoordinates(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        print(newLocation)
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("locationManager didFailWithError: \(error)")
    }
}



