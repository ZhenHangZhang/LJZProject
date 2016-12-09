
//
//  LJZRecommView.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/8.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit


let ident = "reviewIdent"


class LJZRecommView: UIView {
    
    typealias TapBlock = ()->(Void)
    
    var tBlock : TapBlock?
    
    
    fileprivate var segmented:UISegmentedControl?
    
    var dataS : [LJZParkInfoModel]?{
    
        didSet{
        reView.reloadData()
        }
    }
    var seletIndex : Int?{
        didSet{
            segmented?.selectedSegmentIndex = seletIndex!//默认选中第二项
            let index = IndexPath(item: seletIndex!, section: 0)
            reView.scrollToItem(at: index, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        }
    }
    fileprivate lazy var reView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = CGFloat(integerLiteral: 0)//如果是纵向滑动的话即行间距，如果是横向滑动则为列间距
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 0)//如果是纵向滑动的话即列间距，如果是横向滑动则为行间距
        let v = UICollectionView(frame: CGRect(x: 0, y:SCREEN_H/2 + 30, width: SCREEN_W, height: self.bounds.height/2 - 30), collectionViewLayout: layout)
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        ZHZDLog(frame)
        self.backgroundColor = UIColor.white
        self.addSubview(reView)
        reView.backgroundColor = UIColor.white
        reView.delegate = self
        reView.dataSource = self
        reView.isPagingEnabled = true
        reView.showsHorizontalScrollIndicator = false
        reView.register(LJZCollectionViewCell.self, forCellWithReuseIdentifier: ident)
        initSegment()
    }
    private func initSegment(){
        //选项除了文字还可以是图片
        let items = ["按价格排序", "按状态排序"] as [Any]
        segmented = UISegmentedControl(items:items)
        segmented?.frame = CGRect(x: 0, y: SCREEN_H/2, width: SCREEN_W, height: 30)
        segmented?.backgroundColor = UIColor.white
        segmented?.addTarget(self, action: #selector(segmentDidchange), for: .valueChanged)
        addSubview(segmented!)
    }
  @objc private func segmentDidchange(segmented:UISegmentedControl){
        
    ZHZDLog(segmented.selectedSegmentIndex)
    
    let index = IndexPath(item: segmented.selectedSegmentIndex, section: 0)
    
    
    reView.scrollToItem(at: index, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LJZRecommView:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as! LJZCollectionViewCell
        
        cell.dataArr = dataS
        return cell
    }
    //MARK: -----------  UICollectionViewDataSourcePrefetching  预取  缓存 -----
    /*  获取 ‘预取’ 地址集合  item出现之前的预处理,iOS 10.0以后新加的，不明觉厉。。不知道有什么用
     *  目前来看 只能是单纯的提升运行效率   做一下预处理。。。
     *  当界面显示不完 item 时 , 类似复用队列一样可以缓存一部分尚未显示出来的 item ，具体缓存多少目前还没搞清楚，
     *  貌似跟几何面积有关，单个item越大，缓存的行数越少；相反，item的size越小，缓存的行数越多
     func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
     //dump(indexPaths)
     }
     
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: SCREEN_H/2 - 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
 
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
 
        
        let point = targetContentOffset.move()
        if point.x == 0 {
            segmented?.selectedSegmentIndex = 0
        }else{
            segmented?.selectedSegmentIndex = 1
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
        
        if tBlock != nil {
            tBlock!()
        }
    }
    
}



