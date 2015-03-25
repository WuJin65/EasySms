//
//  TemlateDetailViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-11.
//  Copyright (c) 2015 zxinc. All rights reserved.
//

import UIKit

class TemlateDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var reasonText: UITextField!
    @IBOutlet weak var moneyText: UITextField!
    @IBOutlet weak var lastDayText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var mobilePhoneText: UITextField!
    @IBOutlet weak var addressSwitch: UISwitch!
    @IBOutlet weak var mibilePhoneSwitch: UISwitch!
    @IBOutlet weak var contentCountLable: UILabel!
    @IBOutlet weak var previewContentTextView: UITextView!
    @IBOutlet weak var lastDayDatePicker: UIDatePicker!
    
    var address = NSUserDefaults().objectForKey(kAddress) as String!
    var mobilePhone = NSUserDefaults().objectForKey(kTelPhone) as String!
    var content = ""
    var params = [("$param1", ""),("$param2", ""),("$param3", ""),("$param4", ""),("$param5", "")]
    var template: TemlateModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hidesBottomBarWhenPushed = true
        reasonText.delegate = self
        moneyText.delegate = self
        lastDayText.delegate = self
        addressText.delegate = self
        mobilePhoneText.delegate = self
        previewContentTextView.delegate = self
        
        content = template!.temContent
        //var aa = content.stringByReplacingOccurrencesOfString("$param1", withString: "值1周年店庆", options: nil, range: nil)
        //var bb = aa.stringByReplacingOccurrencesOfString("$param2", withString: "5元", options: nil, range: nil)
        //println(bb)
        
        previewContentTextView.text = template?.content
        var contentCount = previewContentTextView.text.utf16Count
        contentCountLable.text = "预览：\(contentCount)个字"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickAddressSwitch(sender: AnyObject) {
        hideKeyboard()
        lastDayDatePicker.hidden = true
        if addressSwitch.on {
            addressText.text = address
            previewContentTextView.text = previewContentTextView.text + "地址：" + address + "。"
            content = content + "地址：" + address + "。"
        } else {
            var previewContent = previewContentTextView.text
            previewContent = previewContent.stringByReplacingOccurrencesOfString("地址：" + address + "。", withString: "", options: nil, range: nil)
            content = content.stringByReplacingOccurrencesOfString("地址：" + address + "。", withString: "", options: nil, range: nil)
            previewContentTextView.text = previewContent
            addressText.text = ""
        }
        //previewContentTextView.text = previewContentTextView.text + addressText.text
        var contentCount = previewContentTextView.text.utf16Count
        contentCountLable.text = "预览：\(contentCount)个字"
    }
    @IBAction func clickMobilePhoneSwitch(sender: AnyObject) {
        hideKeyboard()
        lastDayDatePicker.hidden = true
        if mibilePhoneSwitch.on {
            mobilePhoneText.text = mobilePhone
            previewContentTextView.text = previewContentTextView.text + "电话：" + mobilePhone + "。"
            content = content + "电话：" + mobilePhone + "。"
        } else {
            var previewContent = previewContentTextView.text
            previewContent = previewContent.stringByReplacingOccurrencesOfString("电话：" + mobilePhone + "。", withString: "", options: nil, range: nil)
            content = content.stringByReplacingOccurrencesOfString("电话：" + mobilePhone + "。", withString: "", options: nil, range: nil)
            previewContentTextView.text = previewContent
            mobilePhoneText.text = ""
        }
        //previewContentTextView.text = previewContentTextView.text + mobilePhoneText.text
        var contentCount = previewContentTextView.text.utf16Count
        contentCountLable.text = "预览：\(contentCount)个字"
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == lastDayText {
            hideKeyboard()
            lastDayDatePicker.hidden = false
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == reasonText {
            //previewContentTextView.text = previewContentTextView.text + textField.text
            params[0].1 = textField.text + "，"
        } else if textField == moneyText {
            //previewContentTextView.text = previewContentTextView.text + textField.text
            params[1].1 = textField.text
            params[4].1 = textField.text
        }
        previewContentTextView.text = previewContent()
        var contentCount = previewContentTextView.text.utf16Count
        contentCountLable.text = "预览：\(contentCount)个字"
    }
    
    // Dismiss the keyboard
    // MARK: - Textfield
    /*
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }*/
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        hideKeyboard()
        if !lastDayDatePicker.hidden {
            let locale = NSLocale(localeIdentifier: "zh_CN")
            let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd", options:0, locale:locale)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = dateFormat
            lastDayText.text = dateFormatter.stringFromDate(lastDayDatePicker.date)
            params[3].1 = lastDayText.text
            previewContentTextView.text = previewContent()
        }
        lastDayDatePicker.hidden = true
    }
    
    func previewContent() -> String {
        var previewContent = content
        for elm in params {
            var key = elm.0
            var value = elm.1
            previewContent = previewContent.stringByReplacingOccurrencesOfString(key, withString: value, options: nil, range: nil)
        }
        return previewContent
    }
    
    func hideKeyboard() {
        reasonText.resignFirstResponder()
        moneyText.resignFirstResponder()
        lastDayText.resignFirstResponder()
        addressText.resignFirstResponder()
        mobilePhoneText.resignFirstResponder()
    }
    
    // Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tc = segue.destinationViewController as SelectPhoneNumberViewController
        var addressStatus: Int
        var telStatus: Int
        if addressSwitch.on {
            addressStatus = 1
        } else {
            addressStatus = 0
        }
        if mibilePhoneSwitch.on {
            telStatus = 1
        } else {
            telStatus = 0
        }
        tc.content = previewContentTextView.text
        tc.templateId = template?.id
        tc.variableObj = "{'$param1':'\(reasonText.text)','$param2':\(moneyText.text),'$param4':'\(lastDayText.text)','$param5':\(moneyText.text),'addAddressFlag':\(addressStatus),'addPhoneFlag':\(telStatus)}"
    }
    
}