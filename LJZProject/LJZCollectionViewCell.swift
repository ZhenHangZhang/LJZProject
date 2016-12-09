//
//  LJZCollectionViewCell.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/8.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

fileprivate let inden = "LJZCollectionViewCellIdent"


class LJZCollectionViewCell: UICollectionViewCell {
    
    var dataArr : [LJZParkInfoModel]?{
    
        didSet{
            Tab.reloadData()
        }
    }
    fileprivate lazy var Tab : UITableView = {
        let leftTab = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), style: .plain)
        leftTab.register(UINib.init(nibName: "LJZCustomTableViewCell", bundle: nil), forCellReuseIdentifier: inden)
        return leftTab
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        ZHZDLog(frame)
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
         self.addSubview(Tab)
        Tab.delegate = self
        Tab.dataSource = self
        Tab.backgroundColor = UIColor.white
//        Tab.separatorStyle = .none
//        self.contentView.autoresizesSubviews = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LJZCollectionViewCell:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArr?.count)!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: inden) as!LJZCustomTableViewCell
        cell.index = indexPath as NSIndexPath?
        cell.mocel = self.dataArr?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
 
    }
}

