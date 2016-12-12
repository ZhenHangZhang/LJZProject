//
//  LJZCustomNetWork.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/6.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import Foundation

class LJZCustomNetWork:NSObject{
    
    static let share = LJZCustomNetWork()
 
    // MARK:- get请求
    func getWithPath(path: String,paras: Dictionary<String,Any>?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        
        var i = 0
        var address = path
        if let paras = paras {
            for (key,value) in paras {
                if i == 0 {
                    address += "?\(key)=\(value)"
                }else {
                    address += "&\(key)=\(value)"
                }
                i += 1
            }
        }
        let url = URL(string: address.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    
        ZHZDLog("\(url)")
        let session = URLSession.shared

        /// [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        let dataTask = session.dataTask(with: url!) { (data, respond, error) in
            ZHZDLog(data)

            if let data = data {
                do{
                    let responseData:NSArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSArray
                    print("responseData:\(responseData)")
                }catch{
                    print("catch")
                }
            }else {
                failure(error!)
            }
        }
        dataTask.resume()
    
    }

    // MARK:- post请求
    func postWithPath(path: String,paras: Dictionary<String,Any>?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        
        var i = 0
        var address: String = ""
        
        if let paras = paras {
            
            for (key,value) in paras {
                
                if i == 0 {
                    
                    address += "\(key)=\(value)"
                }else {
                    
                    address += "&\(key)=\(value)"
                }
                
                i += 1
            }
        }
        let url = URL(string: path)
        var request = URLRequest.init(url: url!)
        request.httpMethod = "POST"
        print(address)
        request.httpBody = address.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, respond, error) in
            
            print(data!)
            
            if let data = data {
                
                if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    
                    success(result)
                }
                
            }else {
                failure(error!)
            }
        }
        dataTask.resume()
    }

    func getrequest(paramDic:[String:String]){
        
        let url = URL(string:"https://b2b.ezparking.com.cn/rtpi-service/parking")
        var request = URLRequest(url: url!)
        
        let list  = NSMutableArray()
//        var paramDic = [String: String]()
        
        if paramDic.count > 0 {
            //设置为POST请求
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //拆分字典,subDic是其中一项，将key与value变成字符串
            for subDic in paramDic {
                let tmpStr = "\(subDic.0)=\(subDic.1)"
                list.add(tmpStr)
            }
            //用&拼接变成字符串的字典各项
            let paramStr = list.componentsJoined(by: "&")
            ZHZDLog(paramStr)
            //UTF8转码，防止汉字符号引起的非法网址
            let paraData = paramStr.data(using: String.Encoding.utf8)
            ZHZDLog(paraData)
            //设置请求体
            request.httpBody = paraData
        }
        let configuration:URLSessionConfiguration = URLSessionConfiguration.default
        let session:URLSession = URLSession(configuration: configuration)
        let task:URLSessionDataTask = session.dataTask(with: request) { (data, response, error)->Void in
            if error == nil{
                print(data!)
                do{
                    let responseData:NSArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                    
                    print("response:\(response)")
                    print("responseData:\(responseData)")
                    
                }catch{
                    print("catch")
                }
            }else{
                print("error:\(error)")
            }
        }
        // 启动任务
        task.resume()
    }

    // 闭包的类型: (参数列表) -> (返回值类型)
    func loadData(_ callBack : @escaping (_ jsonData : String) -> ()) {
        //这里跟之前的区别不大，参数有些差异
        DispatchQueue.global(qos: .userInitiated).async { () -> Void in
            print("发送网络请求:\(Thread.current)")
            
            DispatchQueue.main.sync(execute: { () -> Void in
                print("获取到数据,并且进行回调:\(Thread.current)")
                
                callBack("jsonData数据")
            })
        }
    }
}
