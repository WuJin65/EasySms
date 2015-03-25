//
//  BillModel.swift
//  YYB
//
//  Created by zxinc on 15-3-13.
//  Copyright (c) 2015年 zxinc. All rights reserved.
//

import Foundation

class BillModel : NSObject{
    var sendTime: String
    var totalNum: Int
    var successNum: Int
    var cost: String
    
    init (sendTime: String, totalNum: Int, successNum: Int, cost: String) {
        self.sendTime = sendTime
        self.totalNum = totalNum
        self.successNum = successNum
        self.cost = cost
    }
}