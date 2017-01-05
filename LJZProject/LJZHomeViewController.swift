//
//  LJZHomeViewController.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit
import MJExtension
import Alamofire
import SVProgressHUD
import MapKit

fileprivate let idenf = "justone"


class LJZHomeViewController: LJZBaseViewController {
    fileprivate var mapView : MAMapView?
    fileprivate var userCoor : CLLocationCoordinate2D?
    fileprivate var dataArr = [LJZParkInfoModel]()
    fileprivate var annArr = [LJZParkingModel]()
    
    fileprivate var lineArr = [MAPolyline]()
    
    fileprivate var isRecommend : Bool?
    fileprivate lazy var recommedView : LJZRecommView = {
        let reiew = LJZRecommView(frame: CGRect(x: 0, y:0, width: SCREEN_W, height: SCREEN_H))
        reiew.backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)
        return reiew
    }()
    fileprivate lazy var infoView : LJZParkingInfoView = {
        let nib = UINib.init(nibName: "LJZParkingInfoView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! LJZParkingInfoView
        v.frame = CGRect(x: 0, y: SCREEN_H , width: SCREEN_W , height: 100)
        return v
    }()
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        isRecommend = true
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        NotificationCenter.default.addObserver(self, selector: #selector(nav), name: NSNotification.Name(rawValue: "nav"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(detail), name: NSNotification.Name(rawValue: "detail"), object: nil)
        self.title = "陆家嘴停车"
        initMapview()
        initBtn()
        initnav()
        view.addSubview(infoView)
        infoView.block = {[weak self](model) in
            ZHZDLog("导航\(model)")
           self?.navigationClick(model: model)
        }
        recommedView.tBlock = {[weak self] in
            self?.tabBarController?.tabBar.isHidden = false
            self?.isRecommend = true
        }
        infoView.tapBlock = {[weak self](model) in
           self?.pushDetailVC(model: model)
        }
    }
    
    private func pushDetailVC(model:LJZParkInfoModel){
        let detailVC = LJZDetailViewController()
        detailVC.model = model
        detailVC.view.backgroundColor = UIColor.white
        detailVC.title = "停车场详情"
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func detail(notifi:Notification){
        let  model = notifi.object as!LJZParkInfoModel
        pushDetailVC(model: model)
    }
    @objc private func nav(notifi:Notification){
        ZHZDLog("导航")
        let  model = notifi.object as!LJZParkInfoModel
        navigationClick(model: model)
    }
    
}

// MARK: - UI
extension LJZHomeViewController{

    fileprivate func navigationClick(model:LJZParkInfoModel){
    
        var navListArr = ["苹果地图"]
        
        let maPschemeArr = ["comgooglemaps://","iosamap://navi","baidumap://map/"]
        
        for scheme in maPschemeArr.enumerated() {
            if UIApplication.shared.canOpenURL(URL(string: scheme.element)!) {
                if scheme.offset == 0 {
                    navListArr.append("谷歌地图")
                }else if scheme.offset == 1{
                    navListArr.append("高德地图")
                }else if scheme.offset == 2{
                    navListArr.append("百度地图")
                }
            }
        }
        let alertVC = UIAlertController(title: "提示", message: "选择", preferredStyle: .actionSheet)
        for name in navListArr {
        let action = UIAlertAction(title: name, style: .default, handler: { (action) in
        ZHZDLog(name)
        self.navMap(name: name, model: model)
        })
          alertVC.addAction(action)
        }
        let canAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
         })
        alertVC.addAction(canAction)
        present(alertVC, animated: true, completion: nil)
    }

    private func navMap(name:String,model:LJZParkInfoModel){
    
        var strCoord :String?
        if name == "百度地图" {
            strCoord = model.coordinateBaidu
        }else{
            strCoord = model.coordinateAmap
        }
        let coorArr = strCoord?.components(separatedBy: ",")
        if coorArr?.count == 2 {
            let coord = CLLocationCoordinate2DMake(Double((coorArr?.last)!)!, Double((coorArr?.first)!)!)
            if name == "苹果地图" {
                let toLocation = MKMapItem(placemark: MKPlacemark(coordinate: coord, addressDictionary: nil))
                MKMapItem.openMaps(with: [MKMapItem.forCurrentLocation(),toLocation], launchOptions: NSDictionary.init(objects: NSArray.init(objects: MKLaunchOptionsDirectionsModeDriving,NSNumber.init(booleanLiteral: true)) as! [Any], forKeys: NSArray.init(objects: MKLaunchOptionsDirectionsModeKey,MKLaunchOptionsShowsTrafficKey) as! [NSCopying]) as? [String : Any])
            }else if (name == "谷歌地图"){
                let amapUrl = NSURL.init(string: NSString.localizedStringWithFormat("comgooglemaps://?saddr=%.8f,%.8f&daddr=%@,%@&directionsmode=transit",(userCoor?.latitude)!,(userCoor?.longitude)!,(coorArr?.last)!,(coorArr?.first)!) as String)
                UIApplication.shared.openURL(amapUrl as! URL)
            }else if (name == "百度地图"){
                let baiduUrl = NSURL.init(string: NSString.localizedStringWithFormat("baidumap://map/direction?origin=%.8f,%.8f&destination=%@,%@&&mode=driving",(userCoor?.latitude)!,(userCoor?.longitude)!,(coorArr?.last)!,(coorArr?.first)!) as String)
                UIApplication.shared.openURL(baiduUrl as! URL)
            }else if (name == "高德地图"){
                let amapUrl = NSURL.init(string: NSString.localizedStringWithFormat("iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=%@&poiid=BGVIS&lat=%@&lon=%@&dev=0&style=2","",(coorArr?.last)!,(coorArr?.first)!) as String)
                UIApplication.shared.openURL(amapUrl as! URL)
            }
        }

    }
    
    fileprivate func initBtn(){
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: SCREEN_W - 50, y: 100, width: 40, height: 40)
        rightBtn.layer.masksToBounds = true
        rightBtn.layer.cornerRadius = 20
        rightBtn.setBackgroundImage(UIImage.init(named: "user_location"), for: .normal)
        rightBtn.addTarget(self, action: #selector(userLocation), for: .touchUpInside)
        view.addSubview(rightBtn)
    }
    fileprivate func initnav(){
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.setTitleColor(UIColor.black, for: .normal)
        rightBtn.setTitle("推荐", for: .normal)
        rightBtn.showsTouchWhenHighlighted = true
        rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        rightBtn.addTarget(self, action: #selector(recommendedPark), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    
    /// 推荐停车场
    @objc private func recommendedPark(){
        
        
        if isRecommend == false {
            recommedView.removeFromSuperview()
            self.tabBarController?.tabBar.isHidden = false
            isRecommend = true
            return;
        }
        infoView.frame = CGRect(x: 0, y: SCREEN_H , width: SCREEN_W, height: 100)

        let alert = UIAlertController(title: "提示", message: "推荐类型", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "按价格排序", style: .default, handler: { [weak self](action) in
            self?.recommendpark(index:0)
        }))
        
        alert.addAction(UIAlertAction(title: "按状态排序", style: .default, handler: { [weak self](action) in
            self?.recommendpark(index:1)

        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func recommendpark(index:Int){
        self.tabBarController?.tabBar.isHidden = true
        recommedView.seletIndex = index
        recommedView.dataS = self.dataArr
        view.addSubview(recommedView)
        isRecommend = !isRecommend!
    }
    
    /// 用户位置
    @objc private func userLocation(){
    
        if userCoor != nil {
            mapView?.setCenter(userCoor!, animated: true)
        }else{
        SVProgressHUD.show(UIImage.init(named: "Close@2x"), status: "获取用户位置失败")
        }
    }
    fileprivate func initMapview(){
        if (mapView == nil)
        {
            mapView = MAMapView(frame: CGRect(x: 0, y: 64 , width: SCREEN_W, height: SCREEN_H - 64))
        }
        mapView?.delegate = self;
        mapView?.showsScale = true;
        //罗盘的位置
        mapView?.isRotateEnabled = false
        mapView?.compassOrigin = CGPoint(x: 5, y: 14)
        mapView?.scaleOrigin = CGPoint(x:5, y:SCREEN_H - 64 - 20);
        mapView?.logoCenter = CGPoint(x:50, y: SCREEN_H - 64 - 20 - 20);
        let coord = CLLocationCoordinate2DMake(31.237524, 121.5128895)
        mapView?.zoomLevel = 15;
        mapView?.setCenter(coord, animated: false)
        mapView?.showsUserLocation = true
        mapView?.mapType = .standard
        mapView?.userTrackingMode = .none
        view.addSubview(mapView!)
    }
}

// MARK: - MAMapViewDelegate
extension LJZHomeViewController:MAMapViewDelegate{
    
    /// 用户位置获取失败
    ///
    /// - Parameters:
    ///   - mapView:
    
    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
        ZHZDLog(error)
        SVProgressHUD.show(UIImage.init(named: "Close@2x"), status: "获取用户位置失败")
    }
    
    /// 获取用户位置
    ///
    /// - Parameters:
    ///   - mapView:
    ///   - userLocation:
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        userCoor = userLocation.coordinate
    }
    /// 地图加载完成
    ///
    /// - Parameter mapView:
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        
        
    }
    
    /// 地图区域即将发生变化
    ///
    /// - Parameters:
    ///   - mapView:
    ///   - animated:
    func mapView(_ mapView: MAMapView!, regionWillChangeAnimated animated: Bool) {
        infoView.frame = CGRect(x: 0, y: SCREEN_H, width: SCREEN_W, height: 100)
    }
    
    /// 地图区域已经发生变化
    ///
    /// - Parameters:
    ///   - mapView:
    ///   - animated:
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        let zoom = mapView.zoomLevel
        ZHZDLog("\(zoom)")
      let dictParamas = ["key":"4tj2bDvzSDHb","type":"status"]
        getData(dic: dictParamas as [String : AnyObject])
    }
    
    /// 大头针模型视图
    ///
    /// - Parameters:
    ///   - mapView:
    ///   - annotation:
    /// - Returns:
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: LJZParkingModel.self) {
            var annView = mapView.dequeueReusableAnnotationView(withIdentifier: idenf) as? LJZCustomAnnVuew
            if annView == nil {
                annView = LJZCustomAnnVuew(annotation: annotation, reuseIdentifier: idenf)
                annView?.canShowCallout = false;
                annView?.isDraggable = false;
                annView?.calloutOffset = CGPoint(x:0, y:-5);
            }
            let index = (annotation as!LJZParkingModel).tag
            annView?.model = ((dataArr as NSArray).object(at: index))as?LJZParkInfoModel
            return annView
        }
        return nil
    }
    
    /// 选择大头针的方法
    ///
    /// - Parameters:
    ///   - mapView:
    ///   - view:
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        if infoView.frame.origin.y == SCREEN_H {
            infoView.frame = CGRect(x: 0, y: SCREEN_H - 100 - 50, width: SCREEN_W, height: 100)
        }
        if view.isKind(of: LJZCustomAnnVuew.self) {
            let annimation = view.annotation as!LJZParkingModel
            let model = dataArr[annimation.tag]
              showParkInfoView(model: model)
        }
    }
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        infoView.frame = CGRect(x: 0, y: SCREEN_H , width: SCREEN_W, height: 100)
        self.tabBarController?.tabBar.isHidden = false
        recommedView.removeFromSuperview()
        ZHZDLog(coordinate)
    }
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let polylineRenderer = MAPolylineRenderer(overlay: overlay)
            if ((mapView.zoomLevel >= 15) && (mapView.zoomLevel < 17)){
                polylineRenderer?.strokeColor = UIColor.blue
                polylineRenderer?.lineDash = false
            }else if ((mapView.zoomLevel >= 17) && (mapView.zoomLevel <= 19)){
                polylineRenderer?.strokeColor = UIColor.red
                polylineRenderer?.lineDash = true
            }
            polylineRenderer?.lineWidth   = 5;
            polylineRenderer?.lineCapType = kMALineCapSquare;
            return polylineRenderer
        }
        return nil
    }
}
// MARK: - 私有方法
extension LJZHomeViewController{

    fileprivate func showParkInfoView(model:LJZParkInfoModel){
        infoView.model = model
    }
    
    /// 获取数据
    ///
    /// - Parameter dic:
    fileprivate func getData(dic:[String:AnyObject]){
        let width = mapView?.bounds.size.width;
        let height = mapView?.bounds.size.height;
        let topLeft = mapView?.convert(CGPoint(x: 0, y: 0), toCoordinateFrom: mapView)
        let topRight = mapView?.convert(CGPoint(x: width!, y: 0), toCoordinateFrom: mapView)
        let bottomRight = mapView?.convert(CGPoint(x: width!, y: height!), toCoordinateFrom: mapView)
        let bottomLeft = mapView?.convert(CGPoint(x: 0, y: height!), toCoordinateFrom: mapView)
        let strBounds = "\(Float(topLeft!.longitude)),\(Float(topLeft!.latitude));\(Float(topRight!.longitude)),\(Float(topRight!.latitude));\(Float(bottomRight!.longitude)),\(Float(bottomRight!.latitude));\(Float(bottomLeft!.longitude)),\(Float(bottomLeft!.latitude))"
        
        var dict = [String:AnyObject]()
        dict["key"] = dic["key"]
        dict["type"] = dic["type"]
        dict["bounds"] = strBounds as AnyObject?
        
        LJZCustomNetWork().getWithPath(path: "https://b2b.ezparking.com.cn/rtpi-service/parking", paras: dict, success: {(res) in
        
        }, failure: {(error) in
        
        
        })
        
        
        
        
        LJZNetworkManager.shared.requestData(parameters: dict, competopm: {[weak self] result in
            if result?.isKind(of: NSError.self) == true{
            }else{
                SVProgressHUD.setStatus("网络获取错误")
            let arr = LJZParkInfoModel.mj_objectArray(withKeyValuesArray: result!)
                
                self?.dataArr.removeAll()
                self?.annArr.removeAll()
                self?.mapView?.removeAnnotations(self?.mapView?.annotations)
                self?.mapView?.removeOverlays(self?.mapView?.overlays)
                for model in arr!{
                self?.dataArr.append(model as! LJZParkInfoModel)
                self?.annArr.append((self?.initParkingModel(model: model as! LJZParkInfoModel))!)
                    if ((model as! LJZParkInfoModel).name?.contains("占道"))!{
                        self?.lineArr.append((self?.initPloyline(model: model as! LJZParkInfoModel))!)
                    }
                }
                if (self?.lineArr.count)! > 0{
                    self?.mapView?.addOverlays(self?.lineArr)
                }
                self?.mapView?.addAnnotations(self?.annArr)
            self?.recommedView.dataS = self?.dataArr
            }
        })
    }
    
    private func initPloyline(model:LJZParkInfoModel) -> MAPolyline{
    
        let startArr = model.entranceCoordinatesAmap?.components(separatedBy: ",")
        let endArr = model.exitusCoordinatesAmap?.components(separatedBy: ",")
        let coor1 = CLLocationCoordinate2D(latitude: Double((startArr?.last)!)!, longitude: Double((startArr?.first)!)!)
        let coor2 = CLLocationCoordinate2D(latitude: Double((endArr?.last)!)!, longitude: Double((endArr?.first)!)!)
        var commArr = [coor1,coor2]
        let ployline = MAPolyline(coordinates: &commArr, count: 2)
        return ployline!
    }
    
    /// 创建大头针模型
    ///
    /// - Parameter model:
    private func initParkingModel(model:LJZParkInfoModel) -> LJZParkingModel{
        let ann = LJZParkingModel()
        let arr =  model.coordinateAmap?.components(separatedBy: ",")
        let coor = CLLocationCoordinate2D(latitude:Double((arr?.last)!)!, longitude:Double((arr?.first)!)!)
        ann.coordinate = coor
        ann.name = model.name!
        ann.tag = dataArr.index(of: model)!
        return ann
    }

}
