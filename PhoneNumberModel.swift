//
//  PhoneNumberModel.swift
//  YYB
//
//  Created by zxinc on 15-3-12.
//  Copyright (c) 2015年 zxinc. All rights reserved.
//

import Foundation

class PhoneNumberModel : NSObject{
    var name: String
    var tel: String
    
    init (name: String, tel: String) {
        self.name = name
        self.tel = tel
    }
}