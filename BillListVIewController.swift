//
//  BillListVIewController.swift
//  YYB
//
//  Created by zxinc on 15-3-13.
//  Copyright (c) 2015年 zxinc. All rights reserved.
//

import UIKit

class BillListVIewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var billList: [BillModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // 初始化账单
        var tel = NSUserDefaults().objectForKey(kTelKey) as? String
        var url = mainUrl + "getBills?mobilePhone=\(tel!)"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        httpRequest(url)
        /*
        let request = YYHRequest(url: NSURL(string: mainUrl + "getBills")!)
        request.method = "GET"
        request.parameters["mobilePhone"] = NSUserDefaults().objectForKey(kTelKey) as? String
        request.loadWithCompletion {response, data, error in
            if let actualError = error {
                println("http request error")
            } else if let actualResponse = response {
                println("http request success")
                self.initTableView(data!)
            }
        }*/
        //billList = [BillModel(sendTime: "3月5日 10:00", totalNum: 1, successNum: 50, cost: 8),BillModel(sendTime: "3月6日 11:00", totalNum: 2, successNum: 48, cost: 7),BillModel(sendTime: "3月8日 12:00", totalNum: 1, successNum: 100, cost: 15)]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        var elm = billList[indexPath.row]
        var sendTime = cell.viewWithTag(101) as UILabel
        var totalNum = cell.viewWithTag(102) as UILabel
        var successNUm = cell.viewWithTag(103) as UILabel
        var cost = cell.viewWithTag(104) as UILabel
        
        sendTime.text = elm.sendTime
        totalNum.text = "短信长度\(elm.totalNum)条"
        successNUm.text = "成功发送：\(elm.successNum)人"
        cost.text = "成本：\(elm.cost)元"
        return cell
        
    }
    /*
    func initTableView(data: NSData) {
        var returnString:NSString?
        returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        //var result = String(returnString!)
        for (key, value) in jsonData {
            var result = key as String
            if result == "result" {
                var resultJson = JSON(value)
                var elm: JSON
                var bill: BillModel
                billList.removeAll(keepCapacity: true)
                for var i = 0;i < resultJson.arrayValue.count;i++ {
                    elm = resultJson[i]
                    var sendTime = elm["sendTime"].stringValue
                    var totalNum = elm["totalNum"].intValue
                    var successNum = elm["successNum"].intValue
                    var cost = elm["cost"].stringValue
                    bill = BillModel(sendTime: sendTime, totalNum: totalNum, successNum: successNum, cost: cost)
                    billList.append(bill)
                }
            }
        }
        self.tableView.reloadData()
    }*/
    
    func httpRequest( urlString:String){
        let requestUrl = NSURL(string: urlString)
        let urlRequest = NSURLRequest(URL: requestUrl!)
        NSURLConnection.sendAsynchronousRequest(urlRequest,queue:NSOperationQueue.mainQueue(),completionHandler:{(response: NSURLResponse!,data:NSData!,error:NSError!)-> Void in
            if error == nil && data?.length > 0{
                var returnString:NSString?
                returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
                let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                var result = JSON(jsonData["result"]!)
                var elm: JSON
                var bill: BillModel
                self.billList.removeAll(keepCapacity: true)
                for var i = 0;i < result.arrayValue.count;i++ {
                    elm = result[i]
                    var sendTime = elm["sendTime"].stringValue
                    var totalNum = elm["totalNum"].intValue
                    var successNum = elm["successNum"].intValue
                    var cost = elm["cost"].stringValue
                    bill = BillModel(sendTime: sendTime, totalNum: totalNum, successNum: successNum, cost: cost)
                    self.billList.append(bill)
                }
                self.tableView.reloadData()
            } else {
                var alert: UIAlertView = UIAlertView()
                alert.title = "提示"
                alert.addButtonWithTitle("确定")
                alert.message = "网络异常"
                alert.show()
                return
            }
        })
    }
    /*
    func connection(connection:NSURLConnection!,didReceiveData data:NSData!){
        var returnString:NSString?
        returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        //var result = String(returnString!)
        for (key, value) in jsonData {
            var result = key as String
            if result == "result" {
                var resultJson = JSON(value)
                var elm: JSON
                var bill: BillModel
                billList.removeAll(keepCapacity: true)
                for var i = 0;i < resultJson.arrayValue.count;i++ {
                    elm = resultJson[i]
                    var sendTime = elm["sendTime"].stringValue
                    var totalNum = elm["totalNum"].intValue
                    var successNum = elm["successNum"].intValue
                    var cost = elm["cost"].stringValue
                    bill = BillModel(sendTime: sendTime, totalNum: totalNum, successNum: successNum, cost: cost)
                    billList.append(bill)
                }
            }
        }
        self.tableView.reloadData()
    }*/
}