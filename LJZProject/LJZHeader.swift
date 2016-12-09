//
//  LJZHeader.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

let MAP_KEY = "00cca6d62ce4e3b45653399748f53513"

/// 宏定义宽高；
let SCREEN_W = UIScreen.main.bounds.size.width
let SCREEN_H = UIScreen.main.bounds.size.height

let IsLogin = "IsLogin"
let USER_NAME = "USERNAME"
let USER_INFO = "USERINFO"
let TABLE_NAME = "BOSO"


let NET_NOTIFITION = "NETWORKNOTIFITION"
let CALENDAR_NOTIFITION = "calendarNotifition"


 


let ZHZUserDefaults = UserDefaults.standard

func SCREEN_WIDTH(_ object:UIView) ->CGFloat{
    
    return object.frame.size.width
}
func SCREEN_HEIGHT(_ object:UIView) ->CGFloat{
    
    return object.frame.size.height
}

func RGBColor(_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(colorLiteralRed: Float(r/255), green: Float(g/255), blue: Float(b/255), alpha: Float(a))
}

func ZHZDLog<T>(_ message:T,fileName:String = #file,methodName:String = #function,lineNum:Int = #line){
    #if DEBUG
        let logStr:String = (fileName as NSString).pathComponents.last!.replacingOccurrences(of: "swift", with: "");
        print("\(logStr)方法\(methodName)行[\(lineNum)]\n :\(message)")
    #endif
}
