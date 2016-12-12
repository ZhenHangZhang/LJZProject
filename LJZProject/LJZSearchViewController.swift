//
//  LJZSearchViewController.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit



class LJZSearchViewController: LJZBaseViewController {
    
    fileprivate var dataArrary : Array<Any> = Array()
    
    fileprivate let tipsSearch = AMapInputTipsSearchRequest()
    
    fileprivate var aMapResult : AMapSearchAPI?
    
    fileprivate lazy var searchBar : UISearchBar = {
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 44))
        bar.delegate = self
        bar.placeholder = "请输入搜索内容"
        return bar
    }()
    
    
    
    fileprivate lazy var searchTab : UITableView = {
        let sTab = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
//        sTab.register(UINib.init(nibName: "LJZCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "LJZSearchViewController")
        return sTab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchTab)
        searchTab.delegate = self
        searchTab.dataSource = self
        searchBar.becomeFirstResponder()
        aMapResult = AMapSearchAPI()
        aMapResult?.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension LJZSearchViewController:UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArrary.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LJZSearchViewController")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "LJZSearchViewController")
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    /// searbar输入改变的时候搜索
    ///
    /// - Parameters:
    ///   - searchBar:
    ///   - searchText:
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tipsSearch.city = "上海市"
        tipsSearch.keywords = searchText
        aMapResult?.aMapInputTipsSearch(tipsSearch)
    }
}

extension LJZSearchViewController:AMapSearchDelegate{

    
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        
        dataArrary.removeAll()
        
        for tip in response.tips {
            let searchModel = LJZSearchModel()
            searchModel.name = tip.name
            searchModel.point = tip.location
            dataArrary.append(searchModel)
        }
        
    searchTab.reloadData()
        
    }
    private func rtpiGetDataMyparks( strKey:String?){
        var strKey = strKey
        if strKey == nil {
            strKey = ""
        }
        LJZNetworkManager.shared.searchData(key: strKey!, competopm: {[weak self] json in
            ZHZDLog(json)
        })
    }
}



