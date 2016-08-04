//
//  ViewController.swift
//  WeatherApp
//
//  Created by wctjerry on 16/8/4.
//  Copyright © 2016年 wctjerry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    

    // MARK: - API call to get data
    func getWeatherData(city: String) {
        // API Key and url
        let API_KEY = "1ebebcdbe10ee40ae73b48e8de648272"
        let url = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&mode=json&APPID=\(API_KEY)"
        
        // prepare for request
        let session = NSURLSession.sharedSession()
        let weatherRequestURL = NSURL(string: url)
        
        // data request
        let dataTask = session.dataTaskWithURL(weatherRequestURL!) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            do {
                //print("Task started")
                
                let weatherData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject]
                self.presentWeatherData(weatherData)
            } catch {
                print("JSON error: ", error)
            }
            
        }
        dataTask.resume()
        
    }
    
    
    // MARK: - Click City Button Action
    @IBAction func clickCityButton(sender: AnyObject) {
        let city = sender.titleLabel!!.text!
        getWeatherData(city)
        
    }
    
    // MARK: - Present weather data
    func presentWeatherData(weatherData: [String: AnyObject]) {
        dispatch_async(dispatch_get_main_queue()){
//            print(weatherData["weather"]![0])
            
            let weather = weatherData["weather"]![0]
            let condition = weather["main"]!! as! String
            let temp = weatherData["main"]!["temp"]!! 
            let textToShow = "Weather: " + condition + "\n" + "\(temp)"
            self.textView.text = textToShow
        }

    }


}

