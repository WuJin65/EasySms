//
//  LoginViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-18.
//  Copyright (c) 2015 zxinc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var telText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        telText.delegate = self
        passwordText.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        var alert: UIAlertView = UIAlertView()
        alert.title = "提示"
        alert.addButtonWithTitle("确定")
        if telText.text == nil || telText.text == "" {
            alert.message = "请输入手机号"
            alert.show()
            return
        }
        if passwordText.text == nil || passwordText.text == "" {
            alert.message = "请输入密码"
            alert.show()
            return
        }
        var url = mainUrl + "login?mobilePhone=\(telText.text)&password=\(passwordText.text)"
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
                    NSUserDefaults.standardUserDefaults().setObject(self.telText.text, forKey: kTelKey)
                    NSUserDefaults.standardUserDefaults().setObject(self.passwordText.text, forKey: kPasswordKey)
                    var shopName = jsonData["shopName"] as String
                    var address = jsonData["address"] as String
                    var telePhone = jsonData["telePhone"] as String
                    NSUserDefaults.standardUserDefaults().setObject(shopName, forKey: kShopName)
                    NSUserDefaults.standardUserDefaults().setObject(address, forKey: kAddress)
                    NSUserDefaults.standardUserDefaults().setObject(telePhone, forKey: kTelPhone)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.dismissViewControllerAnimated(true, completion: nil)
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
    
    // Dismiss the keyboard
    // MARK: - Textfield
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        telText.resignFirstResponder()
        passwordText.resignFirstResponder()
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
        var alert: UIAlertView = UIAlertView()
        alert.title = "提示"
        alert.addButtonWithTitle("确定")
        if result == LOGIN_SUCCESS {
            NSUserDefaults.standardUserDefaults().setObject(telText.text, forKey: kTelKey)
            NSUserDefaults.standardUserDefaults().setObject(passwordText.text, forKey: kPasswordKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if result == ACCOUNT_ERROR{
            alert.message = "手机号未注册"
            alert.show()
        } else if result == LOGIN_FAIL_PASSWORD_ERROR {
            alert.message = "密码错误"
            alert.show()
        }
    }*/
}