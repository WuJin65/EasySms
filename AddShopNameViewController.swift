//
//  AddShopNameViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-18.
//  Copyright (c) 2015 zxinc. All rights reserved.
//

import UIKit

class AddShopNameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var shopNameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var telPhoneText: UITextField!
    
    var tel = NSUserDefaults().objectForKey(kTelKey) as? String
    var password = NSUserDefaults().objectForKey(kPasswordKey) as? String
    override func viewDidLoad() {
        super.viewDidLoad()
        shopNameText.delegate = self
        addressText.delegate = self
        telPhoneText.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func complete(sender: AnyObject) {
        shopNameText.resignFirstResponder()
        addressText.resignFirstResponder()
        telPhoneText.resignFirstResponder()
        var alert: UIAlertView = UIAlertView()
        alert.title = "提示"
        alert.addButtonWithTitle("确定")
        if shopNameText.text == nil || shopNameText.text == "" {
            alert.message = "请输入商铺名称"
            alert.show()
            return
        }
        if addressText.text == nil || addressText.text == "" {
            alert.message = "请输入地址"
            alert.show()
            return
        }
        if telPhoneText.text == nil || telPhoneText.text == "" {
            alert.message = "请输入电话"
            alert.show()
            return
        }
        var url = mainUrl + "registerUser?mobilePhone=\(String(tel!))&password=\(String(password!))&shopName=\(shopNameText.text)&address=\(addressText.text)&telephone=\(telPhoneText.text)&licenseImgUrl="
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
                    NSUserDefaults.standardUserDefaults().setObject(self.shopNameText.text, forKey: kShopName)
                    NSUserDefaults.standardUserDefaults().setObject(self.addressText.text, forKey: kAddress)
                    NSUserDefaults.standardUserDefaults().setObject(self.telPhoneText.text, forKey: kTelPhone)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    NSUserDefaults.standardUserDefaults().setObject("", forKey: kTelKey)
                    NSUserDefaults.standardUserDefaults().setObject("", forKey: kPasswordKey)
                    alert.message = msg
                    alert.show()
                    return
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject("", forKey: kTelKey)
                NSUserDefaults.standardUserDefaults().setObject("", forKey: kPasswordKey)
                alert.message = "网络异常"
                alert.show()
                return
            }
        })
    }
    
    // Dismiss the keyboard
    // MARK: - Textfield
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        shopNameText.resignFirstResponder()
        addressText.resignFirstResponder()
        telPhoneText.resignFirstResponder()
    }
    /*
    func httpRequest( urlString:String){
        var url:NSURL?
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        url=NSURL(string: urlString)!
        requrst=NSURLRequest(URL:url!)
        conn=NSURLConnection(request: requrst!,delegate: self)
        println(conn)
        if((conn) != nil){
            println("http连接成功!")
        }else{
            println("http连接失败!")
        }
    }
    
    func connection(connection:NSURLConnection!,didReceiveData data:NSData!){
        var returnString:NSString?
        returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
        var result = String(returnString!)
        if result == OPER_SUCCESS {
            NSUserDefaults.standardUserDefaults().setObject(tel, forKey: kTelKey)
            NSUserDefaults.standardUserDefaults().setObject(password, forKey: kPasswordKey)
            NSUserDefaults.standardUserDefaults().setObject(shopNameText.text, forKey: kShopName)
            NSUserDefaults.standardUserDefaults().setObject(addressText.text, forKey: kAddress)
            NSUserDefaults.standardUserDefaults().setObject(telPhoneText.text, forKey: kTelPhone)
            NSUserDefaults.standardUserDefaults().synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            var alert: UIAlertView = UIAlertView()
            alert.title = "提示"
            alert.message = "注册失败"
            alert.addButtonWithTitle("确定")
            alert.show()
        }
    }*/
}