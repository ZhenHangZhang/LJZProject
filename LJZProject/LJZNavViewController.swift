//
//  LJZNavViewController.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class LJZNavViewController: UINavigationController {

    lazy var navgation : UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 64))
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置navBar 的标题字体颜色
        navgation.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
        //设置系统按钮的文字渲染颜色  只对系统.plain 的方法有效
        navgation.tintColor = UIColor.orange
        self.setValue(navgation, forKey: "navigationBar")
        
        interactivePopGestureRecognizer?.delegate = self;
    }
    @objc fileprivate func titleBtnAction(){
        popViewController(animated: true)
    }
}

extension LJZNavViewController:UINavigationControllerDelegate,UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return childViewControllers.count > 1
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backBtn = UIButton(type: .custom)
            backBtn.frame = CGRect(x:0, y: 0, width: 26, height: 26)
            backBtn.layer.masksToBounds = true
            backBtn.layer.cornerRadius = 13
            backBtn.setBackgroundImage(UIImage.init(named: "Close"), for: .normal)
            backBtn.addTarget(self, action: #selector(titleBtnAction), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        }
        super.pushViewController(viewController, animated: animated)
    }
}

