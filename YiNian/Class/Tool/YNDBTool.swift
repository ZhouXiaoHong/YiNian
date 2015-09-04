//
//  YNDBTool.swift
//  YiNian
//
//  Created by 周宏 on 15/9/4.
//  Copyright (c) 2015年 Mars. All rights reserved.
//
import SQLite
import Foundation

class YNDBTool {
    private static let db = SQLite.Database((NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String).stringByAppendingPathComponent("yinian.db"))
    
    struct MessageDB {
        static let table = db["nian"]
        // 创建的日期
        static let date = Expression<String>("date")
        // 创建的时间 
        static let dateStamp = Expression<NSTimeInterval>("dateStamp")
        // 文本
        static let text = Expression<String>("text")
        // 图片路径
        static let pic = Expression<String?>("pic")
    }
    
    
    static func createTable() {
        db.create(table: db["nian"], ifNotExists: true) { t in
            println((NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String).stringByAppendingPathComponent("yinian.db"))
            t.column(MessageDB.date, primaryKey: true)
            t.column(MessageDB.dateStamp)
            t.column(MessageDB.text)
            t.column(MessageDB.pic)
        }
    }
}
