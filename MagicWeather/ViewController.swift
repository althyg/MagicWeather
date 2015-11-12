//
//  ViewController.swift
//  MagicWeather
//
//  Created by maiziedu on 11/12/15.
//  Copyright © 2015 Alatan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 城市名
    @IBOutlet weak var cityNameLabel: UILabel!
    // 天气
    @IBOutlet weak var weatherLabel: UILabel!
    // 气温
    @IBOutlet weak var TempLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCityTodayWeatherByName("1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 城市当天的天气
    func getCityTodayWeatherByName(cityName: String) {
    
        let url: NSURL = NSURL(string: "http://api.k780.com:88/?app=weather.today&weaid=\(cityName)&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")!
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error != nil {
                
                NSLog("请求出错！")
            } else {
                
//                let responseString = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                
                do {
                    
                    let jsonData = (try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    
                    self.cityNameLabel.text = jsonData["result"]!["citynm"] as? String
                    self.weatherLabel.text = jsonData["result"]!["weather"] as? String
                    self.TempLabel.text = jsonData["result"]!["temp_curr"] as? String
                    self.TempLabel.text?.appendContentsOf("℃")
                } catch {
                    
                }
            }
        }
    }

    
    // 城市未来一周的天气
    func getCitySevenDaysWeather(cityName: String) {
        
        // http://api.k780.com:88/?app=weather.today&weaid=1&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json
        
        let url: NSURL = NSURL(string: "http://api.k780.com:88/?app=weather.future&weaid=1&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")!

        
        let request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error != nil {
                
                NSLog("请求出错！")
            } else {
                
                let responseString = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                
                do {
                    
                    let jsonData = (try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    print("\(jsonData)")
                } catch {
                    
                }
            }
        }

    }
    
    @IBAction func presenCityContoller(sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Nav") as! UINavigationController
        
        let cityVC = vc.topViewController as! CityListController
        cityVC.selectedCity = { (cityName: String) in
            
            print("\(cityName)")
//            self.getCityTodayWeatherByName(cityName)
        }
        
        cityVC.selectedCityWearID = { (cityWearID: String) in
            
            print("\(cityWearID)")
            self.getCityTodayWeatherByName("\(cityWearID)")
        }
        
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
    }
    
}

