//
//  LJZNetworkManager+g.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import Foundation


extension LJZNetworkManager{

    func searchData(key:String,competopm:@escaping (_ json:AnyObject?) ->()) {
        
        let URLStr = "http://b2b.ezparking.com.cn:8080/rtpi-service/parking?type=status&key=4tj2bDvzSDHb&size=-1&fields=cityName,coordinateAmap,districtName,id,speciesName,status,typeName,name&q=\(key)&city=上海市"
        getRequest(urlString: URLStr, params: [:], success: competopm, failture: competopm)
    }
    
}
extension LJZNetworkManager{
    
    func requestData(parameters:[String:AnyObject],competopm:@escaping (_ json:AnyObject?) ->()) {
        
        let URLStr = "http://b2b.ezparking.com.cn/rtpi-service/parking"
        getRequest(urlString: URLStr, params: parameters, success: competopm, failture: competopm)
    }
}
extension LJZNetworkManager{
    
    
    
    
    
    
}


