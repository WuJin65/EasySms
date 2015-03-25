//
//  ViewController.swift
//  YYB
//
//  Created by zxinc on 15-3-10.
//  Copyright (c) 2015 zxinc. All rights reserved.
//

import UIKit

var temlate: [TemlateModel] = []
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // 初始化短信模版
        var url = mainUrl + "getTemplates"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        httpRequest(url)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temlate.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var elm = temlate[indexPath.row]
        
        var title = cell.viewWithTag(101) as UILabel
        var content = cell.viewWithTag(102) as UITextView
        content.delegate = self
        
        title.text = elm.title
        content.text = elm.content
        
        //cell.accessoryType = UITableViewCellAccessoryType.None
        return cell
    }
    
    // Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "templateDetail" {
            var tc = segue.destinationViewController as TemlateDetailViewController
            tc.hidesBottomBarWhenPushed = true
            var indexPath = tableView.indexPathForSelectedRow()
            if let index = indexPath {
                var elm = temlate[index.row]
                var index = self.tableView.indexPathForSelectedRow()?.row
                var detail: TemlateModel = temlate[index!]
                detail.title = elm.title
                detail.content = elm.content
                tc.template = detail
            }
        } else if segue.identifier == "sendRecord" {
            var tc = segue.destinationViewController as SendRecordViewController
            tc.hidesBottomBarWhenPushed = true
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
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
                var titleName = "模版"
                temlate.removeAll(keepCapacity: true)
                var elm: JSON
                var content: String = ""
                var temContent: String = ""
                var template: TemlateModel
                for var i = 0;i < result.arrayValue.count;i++ {
                    titleName = titleName + "\(i+1)"
                    elm = result[i]
                    temContent = elm["content"].stringValue
                    content = elm["content"].stringValue
                    var variableJSON = elm["variableJSON"].dictionaryValue
                    for (key, value) in variableJSON {
                        content = content.stringByReplacingOccurrencesOfString(key, withString: "\(value)", options: nil, range: nil)
                    }
                    template = TemlateModel(id: elm["id"].intValue, title: titleName, content: content, temContent: temContent)
                    temlate.append(template)
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
                var titleName = "模版"
                temlate.removeAll(keepCapacity: true)
                var elm: JSON
                var content: String = ""
                var temContent: String = ""
                var template: TemlateModel
                for var i = 0;i < resultJson.arrayValue.count;i++ {
                    titleName = titleName + "\(i+1)"
                    elm = resultJson[i]
                    temContent = elm["content"].stringValue
                    content = elm["content"].stringValue
                    var variableJSON = elm["variableJSON"].dictionaryValue
                    for (key, value) in variableJSON {
                        content = content.stringByReplacingOccurrencesOfString(key, withString: "\(value)", options: nil, range: nil)
                    }
                    template = TemlateModel(id: elm["id"].intValue, title: titleName, content: content, temContent: temContent)
                    temlate.append(template)
                }
            }
        }
        self.tableView.reloadData()
    }*/
}

