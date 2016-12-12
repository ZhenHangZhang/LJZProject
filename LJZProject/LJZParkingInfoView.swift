//
//  LJZParkingInfoView.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class LJZParkingInfoView: UIView {

    
    typealias blockHandle = (LJZParkInfoModel)->(Void)

    var block : blockHandle?
    var tapBlock : blockHandle?
    
    
    @IBOutlet weak var titleL: UILabel!
 
    @IBOutlet weak var imgv: UIImageView!

    @IBOutlet weak var statusL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    
    @IBOutlet weak var addressL: UILabel!
    
    @IBOutlet weak var navBtn: UIButton!
    
    @IBAction func btnClick(_ sender: Any) {
        if (block != nil) {
            block!(model!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func tap(_ sender: Any) {
        
      ZHZDLog("tap")
        if (tapBlock != nil) {
            tapBlock!(model!)
        }
    }
    var model : LJZParkInfoModel?{
        didSet{
            ZHZDLog("\(model?.status) \(model?.address)")
            if ((model?.status) != nil) {
                if model?.status == "" {
                    statusL.text = "状态:状态异常或者暂不对外开放"
                }else{
                    statusL.text = "状态:" +  (model?.status)!
                }
            }else{
                statusL.text = "状态:暂不对外开放"
            }
            if ((model?.name) != nil) {
                titleL.text = model?.name
            }
            if ((model?.address) != nil) {
                addressL.text = "地址:" +  (model?.address)!
            }
            if ((model?.feeText) != nil) {
                priceL.text = "价格:" + (model?.feeText)!
            }
            if ((model?.photo) != nil && model?.id != nil) {
                customGCDImg(name: (model?.photo)!, ID: (model?.id)!)
            }
        
            
        }
    }

    func customGCDImg(name:String,ID:String) {
        DispatchQueue.global().async {
            // 子线程下载数据
            let urlStr = "https://pic.ezparking.com.cn/rtpi-service/parking?key=P01890EQ52678RTX&type=photo&id=\(ID)&file=\(name)&thumbnail=1"
            
            let url = URL(string:urlStr)
            let data: Data?
    
            do {
                data =  try? Data(contentsOf: url!)
            }catch {
                print("网络下载数据失败！")
                return
            }
            
            let iamge = UIImage(data: data!)
            DispatchQueue.main.async(execute: {
                self.imgv.image = iamge
            })
        }
    }
}
