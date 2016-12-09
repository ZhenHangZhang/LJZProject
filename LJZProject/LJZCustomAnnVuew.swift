//
//  LJZCustomAnnVuew.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class LJZCustomAnnVuew: MAAnnotationView {
    private let kWidth = 40
    private let kHeight = 40
    private var upImageView : UIImageView?
    private var annImageView : UIImageView?
   
    var model : LJZParkInfoModel?{
        didSet{
            if model?.status == "空" {
                annImageView?.image = UIImage.init(named: "markers_icon3")
            }else if model?.status == "忙" {
                annImageView?.image = UIImage.init(named: "markers_icon")
            }else if model?.status == "满" {
                annImageView?.image = UIImage.init(named: "markers_icon2")
            }else if model?.status == "关" {
                annImageView?.image = UIImage.init(named: "markers_icon5")
            }else {
                annImageView?.image = UIImage.init(named: "markers_icon5")
            }
        }
    }
    override init!(annotation:MAAnnotation!,reuseIdentifier:String!){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.bounds = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(kWidth), height: CGFloat(kHeight))
        self.backgroundColor = UIColor.clear
        /* Create portrait image view and add to view hierarchy. */
//        self.upImageView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(0), width: CGFloat(90), height: CGFloat(28)))
//        self.upImageView?.image = UIImage(named: "annotationView")!
        self.annImageView = UIImageView(frame: CGRect(x: CGFloat((self.frame.size.width) / 2 + 5 - 15), y: CGFloat(5), width: CGFloat(30), height: CGFloat(30)))
        self.annImageView?.image = UIImage(named: "markers_icon3")!.withRenderingMode(.automatic)
//        self.addSubview(self.upImageView!)
        self.addSubview(self.annImageView!)
        /* Create name label. */
//        self.nameLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(0), width: CGFloat(90), height: CGFloat(25)))
//        nameLabel?.textAlignment = .center
//        nameLabel?.textColor = UIColor.white
//        addSubview(nameLabel!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
