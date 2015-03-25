//
//  MemberCenterViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-13.
//  Copyright (c) 2015 zxinc. All rights reserved.
//

import UIKit

class MemberCenterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var itemList = [(image: "yd_center_zd.png",name: "账单")]
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var accountBalance: UILabel!

    @IBOutlet weak var headImgAndAccount: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // 获取会员信息
        /*
        let request = YYHRequest(url: NSURL(string: mainUrl + "getUser")!)
        request.method = "GET"
        request.parameters["mobilePhone"] = NSUserDefaults().objectForKey(kTelKey) as? String
        request.loadWithCompletion {response, data, error in
            if let actualError = error {
                println("http request error")
            } else if let actualResponse = response {
                println("http request success")
                var returnString:NSString?
                returnString=NSString(data:data!,encoding:NSUTF8StringEncoding)
                let jsonData = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                var msg = jsonData["msg"] as? String
                
                if msg == OPER_SUCCESS {
                    self.shopName.text = jsonData["shopName"] as? String
                    var accountBalance = jsonData["accountBalance"] as? String
                    self.accountBalance.text = "账户余额：\(String(accountBalance!))元"
                }
            }
        }*/
        var tel = NSUserDefaults().objectForKey(kTelKey) as? String
        var url = mainUrl + "getUser?mobilePhone=\(tel!)"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        httpRequest(url)
        headImg.image = UIImage(named: "yd_center_h.png")
        var backGroundImg: UIColor = UIColor(patternImage: UIImage(named: "yd_center_t.png")!)
        headImgAndAccount.backgroundColor = backGroundImg
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        var elm = itemList[indexPath.row]
        var itemImg = cell.viewWithTag(101) as UIImageView
        var itemName = cell.viewWithTag(102) as UILabel
        itemImg.image = UIImage(named: elm.image)
        itemName.text = elm.name
        
        return cell
    }
    
    func httpRequest( urlString:String){
        var alert: UIAlertView = UIAlertView()
        alert.title = "提示"
        alert.addButtonWithTitle("确定")
        
        let requestUrl = NSURL(string: urlString)
        let urlRequest = NSURLRequest(URL: requestUrl!)
        NSURLConnection.sendAsynchronousRequest(urlRequest,queue:NSOperationQueue.mainQueue(),completionHandler:{(response: NSURLResponse!,data:NSData!,error:NSError!)-> Void in
            if error == nil && data?.length > 0{
                var returnString:NSString?
                returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
                let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                var success = jsonData["success"] as Bool
                var msg = jsonData["msg"] as String
                if success {
                    self.shopName.text = jsonData["shopName"] as? String
                    var accountBalance = jsonData["accountBalance"] as? String
                    self.accountBalance.text = "账户余额：\(String(accountBalance!))元"
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
    }
    /*
    func connection(connection:NSURLConnection!,didReceiveData data:NSData!){
        var returnString:NSString?
        returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
        let jsonData = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var msg = jsonData["msg"] as? String
        
        if msg == OPER_SUCCESS {
            self.shopName.text = jsonData["shopName"] as? String
            var accountBalance = jsonData["accountBalance"] as? String
            self.accountBalance.text = "账户余额：\(String(accountBalance!))元"
        }
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "billListSegue" {
            var tc = segue.destinationViewController as BillListVIewController
            tc.hidesBottomBarWhenPushed = true
        }
    }
    
}