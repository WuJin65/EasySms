//
//  SelectPhoneNumberViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-12.
//  Copyright (c) 2015 zxinc. All rights reserved.
//

import UIKit

class SelectPhoneNumberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var phoneNumbers: [PhoneNumberModel] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showTableViewButton: UIButton!
    
    var content: String?
    var templateId: Int?
    var variableObj: String?
    var tel = NSUserDefaults().objectForKey(kTelKey) as? String
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.allowsMultipleSelectionDuringEditing = true;
        //navigationItem.leftBarButtonItem = editButtonItem()
        super.setEditing(true, animated: true)
        tableView.setEditing(true, animated: true)
        // 初始化联系人
        var url = mainUrl + "getClientRosters?mobilePhone=\(String(tel!))"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        println(url)
        httpRequest(url)
        phoneNumbers = [PhoneNumberModel(name: "所有联系人", tel: "")]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneNumbers.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var elm = phoneNumbers[indexPath.row]
        
        var name = cell.viewWithTag(101) as UILabel
        var tel = cell.viewWithTag(102) as UILabel
        name.text = elm.name
        tel.text = elm.tel
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            var index: NSIndexPath
            for var i = 1;i < phoneNumbers.count;i++ {
                index = NSIndexPath(forRow: i, inSection: 0)
                self.tableView.selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.Top)
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            var index: NSIndexPath
            for var i = 1;i < phoneNumbers.count;i++ {
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
    @IBAction func submit(sender: AnyObject) {
        var alert: UIAlertView = UIAlertView()
        alert.title = "提示"
        alert.addButtonWithTitle("确定")
        
        var tels: String = ""
        var selectRows: NSArray = self.tableView.indexPathsForSelectedRows()!
        for selectionIndex in selectRows {
            tels = tels + phoneNumbers[selectionIndex.row].tel + ","
        }
        // 创建任务
        var url = mainUrl + "createTask?mobilePhone=\(tel!)&variableObj=\(variableObj!)&templateId=\(templateId!)&telArr=\(tels)"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let requestUrl = NSURL(string:url)
        let urlRequest = NSURLRequest(URL: requestUrl!)
        NSURLConnection.sendAsynchronousRequest(urlRequest,queue:NSOperationQueue.mainQueue(),completionHandler:{(response: NSURLResponse!,data:NSData!,error:NSError!)-> Void in
            if error == nil && data?.length > 0{
            println("http success")
                var returnString:NSString?
                returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
                let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                var success = jsonData["success"] as Bool
                var msg = jsonData["msg"] as String
                if success {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                } else {
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
        let request = YYHRequest(url: NSURL(string: mainUrl + "createTask")!)
        request.method = "GET"
        request.parameters["mobilePhone"] = NSUserDefaults().objectForKey(kTelKey) as? String
        request.parameters["variableObj"] = variableObj
        request.parameters["templateId"] = "\(templateId!)"
        request.parameters["telArr"] = tels

        request.loadWithCompletion {response, data, error in
            if let actualError = error {
                println("http request error")
            } else if let actualResponse = response {
                println("http request success")
                var returnString:NSString?
                returnString=NSString(data:data!,encoding:NSUTF8StringEncoding)
                var resultJson = JSON(returnString!)
                println(resultJson)
                var success = resultJson["success"].boolValue
                println(success)
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    var alert: UIAlertView = UIAlertView()
                    alert.title = "提示"
                    alert.message = resultJson["msg"].stringValue
                    alert.addButtonWithTitle("确定")
                }
            }
        }*/
        
    }
    
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
            self.phoneNumbers.removeAll(keepCapacity: true)
            self.phoneNumbers.append(PhoneNumberModel(name: "所有联系人", tel: ""))
            for var i = 0;i < result.arrayValue.count;i++ {
                elm = result[i]
                phoneNumber = PhoneNumberModel(name: elm["name"].stringValue, tel: elm["tel"].stringValue)
                self.phoneNumbers.append(phoneNumber)
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
        println(returnString)
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        //var result = String(returnString!)
        for (key, value) in jsonData {
            var result = key as String
            if result == "result" {
                var resultJson = JSON(value)
                var elm: JSON
                var phoneNumber: PhoneNumberModel
                phoneNumbers.removeAll(keepCapacity: true)
                phoneNumbers.append(PhoneNumberModel(name: "所有联系人", tel: ""))
                for var i = 0;i < resultJson.arrayValue.count;i++ {
                    elm = resultJson[i]
                    phoneNumber = PhoneNumberModel(name: elm["name"].stringValue, tel: elm["tel"].stringValue)
                    phoneNumbers.append(phoneNumber)
                }
            }
        }
        self.tableView.reloadData()
    }*/
}