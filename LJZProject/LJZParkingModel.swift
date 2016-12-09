//
//  LJZParkingModel.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class LJZParkingModel:NSObject,MAAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var name : String = ""
    var tag : NSInteger = 0

}
