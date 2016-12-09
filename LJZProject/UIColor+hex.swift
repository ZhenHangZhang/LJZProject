//
//  UIColor+hex.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import Foundation

import UIKit

extension UIColor{

    
    ///  透明度固定为1，以0x开头的十六进制转换成的颜色

    ///
    /// - Parameter hexColor:
    /// - Returns:
   func colorWithHex(hexColor:u_long) -> UIColor {
       return colorHex(hexColor: hexColor, opacity: 1.0)
    }
    
    ///  0x开头的十六进制转换成的颜色,透明度可调整
    ///
    /// - Parameters:
    ///   - hexColor:
    ///   - opacity:
    /// - Returns:
    func colorHex(hexColor:u_long,opacity:Float) -> UIColor{

        let red = ((Float)((hexColor & 0xFF0000) >> 16))/255.0
        let green = ((Float)((hexColor & 0xFF00) >> 8))/255.0
        let blue = ((Float)(hexColor & 0xFF))/255.0
        return UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: opacity)
    }
    
    /// // 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor

    ///
    /// - Parameter color:
    /// - Returns:
    func colorWithHexString(color:NSString) -> UIColor {
    
        let cString = color.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() as NSString
        
        if cString.length < 6 {
            return UIColor.clear
        }
        
        if cString.hasPrefix("0X") {
            _ = cString.substring(from: 2)
        }
        if cString.hasPrefix("#") {
            _ = cString.substring(from: 1)
        }
        if cString.length != 6 {
            return UIColor.clear
        }
        
        var range = NSRange()
        range.length = 2
        range.location = 0
        
        let rstring = cString.substring(with: range)
        range.location = 2;

        let gstring = cString.substring(with: range)
        range.location = 4;

        let bstring = cString.substring(with: range)

        
        var r : Int?
        var g : Int?
        var b : Int?

        Scanner(string: rstring).scanInt(&r!)
        Scanner(string: gstring).scanInt(&g!)
        Scanner(string: bstring).scanInt(&b!)
        
return UIColor(colorLiteralRed: Float(r!), green: Float(g!), blue: Float(b!), alpha: 1.0)
    }
    
    
    
    
    
    
    
    
}

