//
//  LJZMainViewController.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class LJZMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setChilers()
    }
    private func setChilers() {
        let homeVC = LJZHomeViewController()
        addChildVC(vc: homeVC, title: "首页", img: "icon3_",seleteImg:"icon3_")
        let searchVC = LJZSearchViewController()
        addChildVC(vc: searchVC, title: "搜索", img: "icon2_",seleteImg:"icon2_")
        let setVC = LJZSetViewController()
        addChildVC(vc: setVC, title: "设置", img: "icon1_",seleteImg:"icon1_")
    }
    private func addChildVC(vc:LJZBaseViewController,title:String,img:String,seleteImg:String){
        vc.title  = title
        let tabBatitem = RAMAnimatedTabBarItem(title: title, image: UIImage.init(named: img), selectedImage: UIImage.init(named: seleteImg))
        let annm = RAMItemAnimation()
        annm.textSelectedColor = UIColor().colorWithHexString(color: "#82050b")
        annm.iconSelectedColor = UIColor().colorWithHexString(color: "#82050b")
        tabBatitem.animation = annm
        tabBatitem.textColor = UIColor.red
        
        //4 修改 tabbar 的标题前景色
        tabBatitem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for:.highlighted)
        //修改字体 系统默认是12号
       tabBatitem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 12)], for: .normal)

        let nav = LJZNavViewController(rootViewController: vc)
        vc.tabBarItem = tabBatitem
        addChildViewController(nav)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
