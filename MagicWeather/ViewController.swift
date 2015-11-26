//
//  ViewController.swift
//  MagicWeather
//
//  Created by maiziedu on 11/12/15.
//  Copyright © 2015 Alatan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // 城市名
    @IBOutlet weak var cityNameLabel: UILabel!
    // 天气
    @IBOutlet weak var weatherLabel: UILabel!
    // 气温
    @IBOutlet weak var TempLabel: UILabel!
    
    
    // 声明 定位管理对象
    var locationManager : CLLocationManager?
    
    // 未来一周天气列表
    var weekWeatherList: SevenDayWeatherList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCityTodayWeatherByCityId("1")
        self.getCitySevenDaysWeatherCityId("1")
        
        // 初始化表视图控制器
        weekWeatherList = self.storyboard?.instantiateViewControllerWithIdentifier("SevenDayWeatherList") as? SevenDayWeatherList
        self.view.addSubview((weekWeatherList?.view)!)
        
        
        // 设置 表视图的 Frame
        let orgY =  CGRectGetMaxY(TempLabel.frame)+20
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let height = CGRectGetHeight(UIScreen.mainScreen().bounds)-orgY
        weekWeatherList?.view.frame = CGRectMake(0, orgY, width, height)
        
        
        
        // 初始化定位相关对象
        locationManager = CLLocationManager()
        locationManager?.delegate = self;
        //设备使用电池供电时最高的精度
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager!.distanceFilter = 10.0 // 单位 10 米

        
        let enable = CLLocationManager.locationServicesEnabled()
        let state = CLLocationManager.authorizationStatus()
        if enable {
            locationManager?.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 城市当天的天气
    func getCityTodayWeatherByCityId(cityID: String) {
    
        let url: NSURL = NSURL(string: "http://api.k780.com:88/?app=weather.today&weaid=\(cityID)&&appkey=16200&sign=e7217822c124768f365911484057a737&format=json")!
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
    func getCitySevenDaysWeatherCityId(cityID: String) {
        
        // http://api.k780.com:88/?app=weather.today&weaid=1&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json
        
        let url: NSURL = NSURL(string: "http://api.k780.com:88/?app=weather.future&weaid=\(cityID)&&appkey=16200&sign=e7217822c124768f365911484057a737&format=json")!

        
        let request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error != nil {
                
                NSLog("请求出错！")
            } else {
                
//                let responseString = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                
                do {
                    
                    let jsonData = (try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    
                    
                    // 属性传值
                    let resultArr = jsonData["result"] as! NSArray
                    self.weekWeatherList?.weatherData = resultArr
                    self.weekWeatherList!.tableView.reloadData()
                    
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
        
        // 闭包传值
        cityVC.selectedCityWearID = { (cityWearID: String) in
            
            print("\(cityWearID)")
            self.getCityTodayWeatherByCityId("\(cityWearID)")
            self.getCitySevenDaysWeatherCityId("\(cityWearID)")
        }
        
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
    }
    
    
    // MARK: - 自动定位当前城市
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        let mLocation = locations.last
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(mLocation!) { (placeMarks, error) -> Void in
            
            if (error != nil) {
                
                return
            }
            
            for pm: CLPlacemark in placeMarks! {
                
                let addrrDic = pm.addressDictionary
                print("\(addrrDic)")
                
                self.cityNameLabel.text = addrrDic!["City"] as? String
                
                //1， 已经拿到城市名字了； 2. 显示当前城市名；  3，获取当前城市对应的天气数据 
                
                
            }
        }
    }
    // MARK: - 结束定位相关代码
    
}

