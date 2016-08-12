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
        let units = "metric"
        let mode = "json"
        let url = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&units=\(units)&mode=\(mode)&APPID=\(API_KEY)"
        
        // create session and URL
        let session = NSURLSession.sharedSession()
        let weatherRequestURL = NSURL(string: url)
        
        // create network request
        let dataTask = session.dataTaskWithURL(weatherRequestURL!) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            // GUARD: no error
            guard (error == nil) else {
                let errorInfo = "Fail to get data from sever. You may need check your Internet access"
                self.updateTextView(errorInfo)
                return
            }

            do {
                // Convert raw data into dictionary
                let weatherData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject]
                self.presentWeatherData(weatherData)
            } catch {
                print("JSON convertion error: ", error)
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
        
        guard let weather = weatherData["weather"]![0],
            let condition = weather["main"]!,
            let temp = weatherData["main"]!["temp"]! else {
            return
        }
        
        
        let textToShow = "Weather: \(condition) \n Temperature: \(temp)"
        
        updateTextView(textToShow)

    }
    
    
    // MARK: - Update TextView
    private func updateTextView(string: String) {
        // process in the main thread
        dispatch_async(dispatch_get_main_queue()){
            self.textView.text = string
        }
    }


}

