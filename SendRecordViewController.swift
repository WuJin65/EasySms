//
//  SendRecordViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-11.
//  Copyright (c) 2015 zxinc. All rights reserved.
//

import UIKit


class SendRecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var sendRecordList: [SendRecordModel] = []
    var tel = NSUserDefaults().objectForKey(kTelKey) as? String
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // 初始化群发记录
        /*
        let request = YYHRequest(url: NSURL(string: mainUrl + "getSendRecords")!)
        request.method = "GET"
        request.parameters["mobilePhone"] = tel
        request.loadWithCompletion {response, data, error in
            if let actualError = error {
                println("http request error")
            } else if let actualResponse = response {
                println("http request success")
                self.initTableView(data!)
            }
        }*/
        var tel = NSUserDefaults().objectForKey(kTelKey) as? String
        var url = mainUrl + "getSendRecords?mobilePhone=\(tel!)"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        httpRequest(url)
        //sendRecordList = [SendRecordModel(sendTime: "02月28日 17:00", statisticsStatus: 0, sendCount: 0, totalCount: 100, smsContent: "你好，值1周年店庆，天懿国际理发店特赠你5元红包一个，持口令123456于03月15日前到店消费可抵5元。"), SendRecordModel(sendTime: "02月28日 17:00", statisticsStatus: 1, sendCount: 48, totalCount: 50, smsContent: "你好，值1周年店庆，天懿国际理发店特赠你5元红包一个，持口令123456于03月15日前到店消费可抵5元。")]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sendRecordList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println(sendRecordList)
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var elm = sendRecordList[indexPath.row]
        
        var sendTime = cell.viewWithTag(101) as UILabel
        var sendCount = cell.viewWithTag(102) as UILabel
        var totalCount = cell.viewWithTag(103) as UILabel
        var smsContent = cell.viewWithTag(104) as UITextView
        smsContent.delegate = self
        
        sendTime.text = elm.sendTime
        if elm.statisticsStatus == 0 {
            sendCount.text = "统计中"
        } else {
            sendCount.text = String(elm.sendCount)
        }
        totalCount.text = String(elm.totalCount)
        smsContent.text = elm.smsContent
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
                var sendRecord: SendRecordModel
                sendRecordList = []
                for var i = 0;i < resultJson.arrayValue.count;i++ {
                    elm = resultJson[i]
                    sendRecord = SendRecordModel(sendTime: elm["sendTime"].stringValue, statisticsStatus: elm["statisticsStatus"].intValue, sendCount: elm["successNum"].intValue, totalCount: elm["toteNum"].intValue, smsContent: elm["smsContent"].stringValue)
                    sendRecordList.append(sendRecord)
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
                self.sendRecordList.removeAll(keepCapacity: true)
                var elm: JSON
                var sendRecord: SendRecordModel
                for var i = 0;i < result.arrayValue.count;i++ {
                    elm = result[i]
                    sendRecord = SendRecordModel(sendTime: elm["sendTime"].stringValue, statisticsStatus: elm["statisticsStatus"].intValue, sendCount: elm["successNum"].intValue, totalCount: elm["toteNum"].intValue, smsContent: elm["smsContent"].stringValue)
                    self.sendRecordList.append(sendRecord)
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
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
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
                sendRecordList.removeAll(keepCapacity: true)
                var elm: JSON
                var sendRecord: SendRecordModel
                for var i = 0;i < resultJson.arrayValue.count;i++ {
                    elm = resultJson[i]
                    sendRecord = SendRecordModel(sendTime: elm["sendTime"].stringValue, statisticsStatus: elm["statisticsStatus"].intValue, sendCount: elm["successNum"].intValue, totalCount: elm["toteNum"].intValue, smsContent: elm["smsContent"].stringValue)
                    sendRecordList.append(sendRecord)
                }
            }
        }
        self.tableView.reloadData()
    }*/
}