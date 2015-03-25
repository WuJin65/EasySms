//
//  ClientRosterViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-12.
//  Copyright (c) 2015年 zxinc. All rights reserved.
//

import UIKit

var clientRosterList: [PhoneNumberModel] = []
class ClientRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var showTableViewButton: UIButton!
    
    var tel = NSUserDefaults().objectForKey(kTelKey) as? String
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsMultipleSelectionDuringEditing = true;
        // 初始化客户名录
        var tel = NSUserDefaults().objectForKey(kTelKey) as? String
        var url = mainUrl + "getClientRosters?mobilePhone=\(tel!)"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        httpRequest(url)
        
        //clientRosterList = [PhoneNumberModel(name: "所有联系人", tel: ""),PhoneNumberModel(name: "吴进", tel: "18872233316"),PhoneNumberModel(name: "余威", tel: "18672920805"),PhoneNumberModel(name: "杨登", tel: "13657237131"),PhoneNumberModel(name: "杜佳富", tel: "13377885181")]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientRosterList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var elm = clientRosterList[indexPath.row]
        
        var name = cell.viewWithTag(101) as UILabel
        var tel = cell.viewWithTag(102) as UILabel
        name.text = elm.name
        tel.text = elm.tel
        return cell
    }
    
    // 新增取消按钮
    @IBAction func addAndCancel(sender: AnyObject) {
        if addBarButton.title == "新增" {
            self.performSegueWithIdentifier("addPhoneNumberSegue", sender: self)
        } else if addBarButton.title == "取消" {
            addBarButton.title = "新增"
            editBarButton.title = "编辑"
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
        }
    }
    
    @IBAction func edit(sender: AnyObject) {
        var alert: UIAlertView = UIAlertView()
        alert.title = "提示"
        alert.addButtonWithTitle("确定")
        if editBarButton.title == "编辑" {
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
            addBarButton.title = "取消"
            editBarButton.title = "删除"
        } else if editBarButton.title == "删除" {
            var tels: String = ""
            var selectRows: NSArray = self.tableView.indexPathsForSelectedRows()!
            for selectionIndex in selectRows {
                tels = tels + clientRosterList[selectionIndex.row].tel + ":"
            }
            // 删除号码
            var url = mainUrl + "deleteClientRoster?mobilePhone=\(tel!)&tels=\(tels)"
            url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let requestUrl = NSURL(string:url)
            let urlRequest = NSURLRequest(URL: requestUrl!)
            NSURLConnection.sendAsynchronousRequest(urlRequest,queue:NSOperationQueue.mainQueue(),completionHandler:{(response: NSURLResponse!,data:NSData!,error:NSError!)-> Void in
                if error == nil && data?.length > 0{
                    var returnString:NSString?
                    returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
                    let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    var success = jsonData["success"] as Bool
                    var msg = jsonData["msg"] as String
                    if success {
                        for var i = 0;i < selectRows.count;i++ {
                            clientRosterList.removeAtIndex(selectRows[i].row-i)
                        }
                        self.tableView.reloadData()
                        self.setEditing(false, animated: false)
                        self.tableView.setEditing(false, animated: false)
                        self.addBarButton.title = "新增"
                        self.editBarButton.title = "编辑"
                    } else{
                        alert.message = msg
                        alert.show()
                        return
                    }
                } else {
                    alert.message = "网络异常"
                    alert.show()
                    return
                }
            })
            /*
            let request = YYHRequest(url: NSURL(string: mainUrl + "deleteClientRoster")!)
            request.method = "GET"
            request.parameters["mobilePhone"] = NSUserDefaults().objectForKey(kTelKey) as? String
            request.parameters["tels"] = tels
            request.loadWithCompletion {response, data, error in
                if let actualError = error {
                    println("http request error")
                } else if let actualResponse = response {
                    println("http request success")
                    var returnString:NSString?
                    returnString=NSString(data:data!,encoding:NSUTF8StringEncoding)
                    var result = String(returnString!)
                    if result == OPER_FAIL {
                        var alert: UIAlertView = UIAlertView()
                        alert.title = "提示"
                        alert.message = "删除失败"
                        alert.addButtonWithTitle("确定")
                    } else if result == OPER_SUCCESS {
                        for var i = 0;i < selectRows.count;i++ {
                            clientRosterList.removeAtIndex(selectRows[i].row-i)
                        }
                        self.tableView.reloadData()
                        self.setEditing(false, animated: false)
                        self.tableView.setEditing(false, animated: false)
                        self.addBarButton.title = "新增"
                        self.editBarButton.title = "编辑"
                    }
                }
            }*/
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            var index: NSIndexPath
            for var i = 1;i < clientRosterList.count;i++ {
                index = NSIndexPath(forRow: i, inSection: 0)
                self.tableView.selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.Top)
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            var index: NSIndexPath
            for var i = 1;i < clientRosterList.count;i++ {
                index = NSIndexPath(forRow: i, inSection: 0)
                self.tableView.deselectRowAtIndexPath(index, animated: true)
            }
        }
    }
    
    @IBAction func showTableView(sender: AnyObject) {
        if showTableViewButton.selected == false {
            showTableViewButton.setImage(UIImage(named: "allowblackdown-selected"), forState: UIControlState.Normal)
            tableView.hidden = false
            showTableViewButton.selected = true
        } else {
            showTableViewButton.setImage(UIImage(named: "allowblackdown"), forState: UIControlState.Normal)
            tableView.hidden = true
            showTableViewButton.selected = false
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    /*
    // 初始化通讯录
    func initClientRosters(data: NSData) {
        var returnString:NSString?
        returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        //var result = String(returnString!)
        for (key, value) in jsonData {
            var result = key as String
            if result == "result" {
                var resultJson = JSON(value)
                var elm: JSON
                var phoneNumber: PhoneNumberModel
                clientRosterList.removeAll(keepCapacity: true)
                clientRosterList.append(PhoneNumberModel(name: "所有联系人", tel: ""))
                for var i = 0;i < resultJson.arrayValue.count;i++ {
                    elm = resultJson[i]
                    phoneNumber = PhoneNumberModel(name: elm["name"].stringValue, tel: elm["tel"].stringValue)
                    clientRosterList.append(phoneNumber)
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
                var phoneNumber: PhoneNumberModel
                clientRosterList.removeAll(keepCapacity: true)
                clientRosterList.append(PhoneNumberModel(name: "所有联系人", tel: ""))
                for var i = 0;i < result.arrayValue.count;i++ {
                    elm = result[i]
                    phoneNumber = PhoneNumberModel(name: elm["name"].stringValue, tel: elm["tel"].stringValue)
                    clientRosterList.append(phoneNumber)
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
                var phoneNumber: PhoneNumberModel
                clientRosterList.removeAll(keepCapacity: true)
                clientRosterList.append(PhoneNumberModel(name: "所有联系人", tel: ""))
                for var i = 0;i < resultJson.arrayValue.count;i++ {
                    elm = resultJson[i]
                    phoneNumber = PhoneNumberModel(name: elm["name"].stringValue, tel: elm["tel"].stringValue)
                    clientRosterList.append(phoneNumber)
                }
            }
        }
        self.tableView.reloadData()
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "addPhoneNumberSegue" {
            var tc = segue.destinationViewController as AddPhoneNumberViewController
            tc.hidesBottomBarWhenPushed = true
        }
    }
    
}