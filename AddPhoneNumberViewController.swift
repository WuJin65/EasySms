//
//  AddPhoneNumberViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-12.
//  Copyright (c) 2015 zxinc. All rights reserved.
//

import UIKit

class AddPhoneNumberViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var telText: UITextField!
    @IBOutlet weak var birthdayText: UITextField!
    @IBOutlet weak var bakText: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    var tel = NSUserDefaults().objectForKey(kTelKey) as? String
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
        telText.delegate = self
        birthdayText.delegate = self
        bakText.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == birthdayText {
            birthdayDatePicker.hidden = false
            return false
        } else {
            return true
        }
    }
    
    // Dismiss the keyboard
    // MARK: - Textfield
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        nameText.resignFirstResponder()
        telText.resignFirstResponder()
        birthdayText.resignFirstResponder()
        bakText.resignFirstResponder()
        if !birthdayDatePicker.hidden {
            let locale = NSLocale(localeIdentifier: "zh_CN")
            let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd", options:0, locale:locale)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = dateFormat
            println(dateFormatter.stringFromDate(birthdayDatePicker.date))
            birthdayText.text = dateFormatter.stringFromDate(birthdayDatePicker.date)
        }
        birthdayDatePicker.hidden = true
    }
    
    @IBAction func okTapped(sender: AnyObject) {
        var alert: UIAlertView = UIAlertView()
        alert.title = "提示"
        alert.addButtonWithTitle("确定")
        
        nameText.resignFirstResponder()
        telText.resignFirstResponder()
        birthdayText.resignFirstResponder()
        bakText.resignFirstResponder()
        // 新增号码
        var url = mainUrl + "saveClientRoster?mobilePhone=\(tel!)&name=\(nameText.text)&tel=\(telText.text)&birthday=\(birthdayText.text)&descr=\(bakText.text)"
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
                    var addPhoneNumber: PhoneNumberModel = PhoneNumberModel(name: self.nameText.text, tel: self.telText.text)
                    clientRosterList.append(addPhoneNumber)
                    self.navigationController?.popToRootViewControllerAnimated(true)
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
        let request = YYHRequest(url: NSURL(string: mainUrl + "saveClientRoster")!)
        request.method = "GET"
        request.parameters["mobilePhone"] = NSUserDefaults().objectForKey(kTelKey) as? String
        request.parameters["name"] = nameText.text
        request.parameters["tel"] = telText.text
        request.parameters["birthday"] = birthdayText.text
        request.parameters["descr"] = bakText.text
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
                    alert.message = "新增失败"
                    alert.addButtonWithTitle("确定")
                } else if result == OPER_SUCCESS {
                    var addPhoneNumber: PhoneNumberModel = PhoneNumberModel(name: self.nameText.text, tel: self.telText.text)
                    clientRosterList.append(addPhoneNumber)
                    self.performSegueWithIdentifier("backToClientRosterSegue", sender: self)
                }
            }
        }*/
    }
}