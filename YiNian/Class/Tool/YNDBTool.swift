//
//  YNDBTool.swift
//  YiNian
//
//  Created by 周宏 on 15/9/4.
//  Copyright (c) 2015年 Mars. All rights reserved.
//
import UIKit

class YNDBTool {
    private static let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String).stringByAppendingPathComponent("yinian.db")
    
    static let formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
        }()
    
    static func createTable() {
        let db = FMDatabase(path: path)
        if db.open() {
            println(path)
            let sql = "CREATE TABLE IF NOT EXISTS nian (date TEXT PRIMARY KEY, dateStamp REAL, text TEXT, pic TEXT)"
            db.executeStatements(sql)
            db.close()
        }
    }
    
    static func insertNian(nian: YNNian) {
        let db = FMDatabase(path: path)
        if db.open() {
            let sql = "INSERT INTO nian VALUES (:date, :dateStamp, :text, :pic)"
            
            if let pic = nian.pic {
                db.executeUpdate(sql, withParameterDictionary: ["date": formatter.stringFromDate(nian.date), "dateStamp":nian.date.timeIntervalSince1970, "text": nian.text, "pic": pic])
            } else {
                db.executeUpdate(sql, withParameterDictionary: ["date": formatter.stringFromDate(nian.date), "dateStamp":nian.date.timeIntervalSince1970, "text": nian.text, "pic": NSNull()])
            }
            
            db.close()
        }
    }
    
    static func deleteTodayNian() {
        let db = FMDatabase(path: path)
        if db.open() {
            let sql = "DELETE FROM nian WHERE date = ?"
            db.executeUpdate(sql, formatter.stringFromDate(NSDate()))
        }
    }
    
    static func queryAllNian() -> Array<YNNian> {
        let db = FMDatabase(path: path)
        var array = Array<YNNian>()
        if db.open() {
            let sql = "SELECT * FROM nian"
            let rs = db.executeQuery(sql)
            if let rs = rs {
                while rs.next() {
                    let nian = YNNian(date:NSDate(timeIntervalSince1970: (rs.doubleForColumn("dateStamp"))), text: rs.stringForColumn("text"), pic: rs.stringForColumn("pic"))
                    array.append(nian)
                }
                return array
            }
            db.close()
        }
        return array
    }
}
