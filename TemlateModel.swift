//
//  TemlateModel.swift
//  YYB
//
//  Created by zxinc on 15-3-10.
//  Copyright (c) 2015年 zxinc. All rights reserved.
//

import Foundation

class TemlateModel : NSObject{
    var id: Int
    var title: String
    var content: String
    var temContent: String
    
    init (id: Int, title: String, content: String, temContent: String) {
        self.id = id
        self.title = title
        self.content = content
        self.temContent = temContent
    }
}