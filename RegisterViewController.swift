//
//  RegisterViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-17.
//  Copyright (c) 2015 zxinc. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var telText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var smsCodeText: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var secondsLable: UILabel!
    
    var remainingSeconds: Int = 0 {
        willSet(newSeconds) {
            
            secondsLable.text = "\(remainingSeconds-1)秒后重发"
            
            if newSeconds <= 0 {
                isCounting = false
                sendCodeButton.hidden = false
                secondsLable.hidden = true
            } else {
                sendCodeButton.hidden = true
                secondsLable.hidden = false
            }
            
        }
    }
    var timer: NSTimer?
    var isCounting: Bool = false {
        willSet(newValue) {
            if newValue {
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
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

    @IBAction func sendCodeTapped(sender: AnyObject) {
        // 发送验证码
        var alert: UIAlertView = UIAlertView()
        alert.title = "提示"
        alert.addButtonWithTitle("确定")
        if telText.text == nil || telText.text == "" {
            alert.message = "请输入手机号"
            alert.show()
            return
        }
        var url = mainUrl + "sendCode?mobilePhone=\(telText.text)"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let requestUrl = NSURL(string:url)
        let urlRequest = NSURLRequest(URL: requestUrl!)
        NSURLConnection.sendAsynchronousRequest(urlRequest,queue:NSOperationQueue.mainQueue(),completionHandler:{(response: NSURLResponse!,data:NSData!,error:NSError!)-> Void in
            if error == nil && data?.length > 0{
                // 倒计时
                self.remainingSeconds = 60
                self.secondsLable.hidden = false
                self.sendCodeButton.hidden = true
                self.secondsLable.text = "\(self.remainingSeconds)秒后重发"
                self.isCounting = !self.isCounting
                
                if self.isCounting {
                    self.createAndFireLocalNotificationAfterSeconds(self.remainingSeconds)
                } else {
                    UIApplication.sharedApplication().cancelAllLocalNotifications()
                }
                
                var returnString:NSString?
                returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
                let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                var success = jsonData["success"] as Bool
                if success {
                    NSUserDefaults.standardUserDefaults().setObject(jsonData["code"] as String, forKey: "smsCode")
                } else{
                    alert.message = jsonData["msg"] as? String
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
    
    func updateTimer(sender: NSTimer) {
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            sendCodeButton.hidden = false
            secondsLable.hidden = true
        }
    }
    
    //Helpers
    
    func createAndFireLocalNotificationAfterSeconds(seconds: Int) {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification = UILocalNotification()
        
        let timeIntervalSinceNow = Double(seconds)
        notification.fireDate = NSDate(timeIntervalSinceNow:timeIntervalSinceNow);
        
        notification.timeZone = NSTimeZone.systemTimeZone();
        notification.alertBody = "计时完成！";
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification);
        
    }
    
    @IBAction func next(sender: AnyObject) {
        telText.resignFirstResponder();
        passwordText.resignFirstResponder()
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
        if passwordText.text.utf16Count < 6 {
            alert.message = "密码不能少于6位"
            alert.show()
            return
        }
        if smsCodeText.text == nil || smsCodeText.text == "" {
            alert.message = "请输入验证码"
            alert.show()
            return
        }
        var smsCode = NSUserDefaults().objectForKey("smsCode") as String
        if smsCodeText.text != smsCode {
            alert.message = "验证码错误"
            alert.show()
            return
        }
        var url = mainUrl + "checkUserExists?mobilePhone=\(telText.text)"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let requestUrl = NSURL(string:url)
        let urlRequest = NSURLRequest(URL: requestUrl!)
        NSURLConnection.sendAsynchronousRequest(urlRequest,queue:NSOperationQueue.mainQueue(),completionHandler:{(response: NSURLResponse!,data:NSData!,error:NSError!)-> Void in
            if error == nil && data?.length > 0{
                var returnString:NSString?
                returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
                let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                var hasUser = jsonData["hasUser"] as Bool
                if hasUser {
                    alert.message = "该手机号已被注册"
                    alert.show()
                    return
                } else {
                    NSUserDefaults.standardUserDefaults().setObject(self.telText.text, forKey: kTelKey)
                    NSUserDefaults.standardUserDefaults().setObject(self.passwordText.text, forKey: kPasswordKey)
                    self.performSegueWithIdentifier("addShopNameSegue", sender: self)
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
        smsCodeText.resignFirstResponder()
    }
}