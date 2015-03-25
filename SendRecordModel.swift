//
//  SendRecordModel.swift
//  YYB
//
//  Created by zxinc on 15-3-11.
//  Copyright (c) 2015年 zxinc. All rights reserved.
//

import Foundation

class SendRecordModel : NSObject{
    var sendTime: String
    var statisticsStatus: Int
    var sendCount: Int
    var totalCount: Int
    var smsContent: String
    
    init (sendTime: String, statisticsStatus: Int, sendCount: Int, totalCount: Int, smsContent: String) {
        self.sendTime = sendTime
        self.statisticsStatus = statisticsStatus
        self.sendCount = sendCount
        self.totalCount = totalCount
        self.smsContent = smsContent
    }
}