//
//  CityListController.swift
//  MagicWeather
//
//  Created by maiziedu on 11/12/15.
//  Copyright © 2015 Alatan. All rights reserved.
//

import UIKit

class CityListController: UITableViewController {

    var citysArr: NSArray?
    var cityWearIds: NSArray?
    
    // 闭包传值
    var selectedCity: ((cityName: String) ->(Void))?
    var selectedCityWearID: ((cityWID: String) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.citysArr = []
        
        // 添加返回按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
        
        //  获取城市列表
        self.getCityList()
    }
    
    func dismiss() {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.citysArr?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        cell.textLabel?.text = self.citysArr![indexPath.row]["citynm"] as! String

        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cityDic: NSDictionary = self.citysArr![indexPath.row] as! NSDictionary
        
        
        selectedCity!(cityName: cityDic["citynm"] as! String)
        
        // 城市 ID
        selectedCityWearID!(cityWID: self.cityWearIds![indexPath.row] as! String)
        
        
        
        self.dismiss()
    }
    
    
    func getCityList() {
        
        let url: NSURL = NSURL(string: "http://api.k780.com:88/?app=weather.city&cou=1&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")!
        
        
        let request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error != nil {
                
                NSLog("请求出错！")
            } else {
                
//                let responseString = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                
                do {
                    
                    // json 数据转字典
                    let jsonData = (try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    
                    // 筛选出 result 字典
                    let result = jsonData["result"] as! NSDictionary
                    
                    // 获取所有地名
                    let citys: NSArray = result.allValues  // 字典都是 key-value
                    
                    self.citysArr = citys
                    self.cityWearIds = result.allKeys as NSArray
                    self.tableView.reloadData()
                } catch {
                    
                }
            }
        }
        
    }


}
