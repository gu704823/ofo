//
//  ViewController.swift
//  ofo
//
//  Created by swift on 2017/5/11.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit
import SafariServices
import SWRevealViewController
class  ViewController: UIViewController {
    ///拖
    @IBAction func locationbtntap(_ sender: UIButton) {
        searchlocation(mapview.userLocation.coordinate)
    }
    
    //定义属性
    var mapview:MAMapView!
    var search:AMapSearchAPI!
    var annotations:[MAPointAnnotation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置ui
        setupui()
        //高德地图定位
        userlocation()
    }
}
extension ViewController:MAMapViewDelegate,AMapSearchDelegate{
    fileprivate func setupui(){
        //设置导航条
        setupnavi()
        //侧边栏
        if self.revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 280
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //初始化高德地图
        mapview = MAMapView(frame: self.view.bounds)
        view.insertSubview(mapview, at:0 )
        //初始化高德地图搜索
        search = AMapSearchAPI()
        search.delegate = self
        
    }
}

extension ViewController{
    //自定义地位点图标样式
    fileprivate func userlocation(){
        //缩放
        mapview.zoomLevel = 17
        //定位
        mapview.showsUserLocation = true;
        mapview.userTrackingMode = .follow
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = true
        r.showsHeadingIndicator = true
        r.fillColor = UIColor.orange
        r.lineWidth = 6
        r.enablePulseAnnimation = true
        r.locationDotBgColor = UIColor.green
        r.locationDotFillColor = UIColor.red
       // r.image = uii
        mapview.update(r)
    }
    //周边检索
    func searchlocation(_ center:CLLocationCoordinate2D){
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "餐馆"
        request.radius = 500
        request.requireExtension = true
        search.aMapPOIAroundSearch(request)
    }
    //周边检索回调方法
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard response.count>0 else {
            return
        }
        //绘制点标记
        annotations = response.pois.map{
        let annotation = MAPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            if $0.distance<200{
                annotation.title = "红包区域内开启任意小黄车"
                annotation.subtitle = "骑行10分钟可获得现金红包"
            }else{
                annotation.title = "正常用车"
            }
            return annotation
        }
        mapview.addAnnotations(annotations)
        mapview.showAnnotations(annotations, animated: true)
    }
}
//导航条
extension ViewController{
    
    fileprivate func setupnavi(){
        let leftbtn = UIButton()
        leftbtn.sizeToFit()
        leftbtn.setImage(#imageLiteral(resourceName: "leftTopImage"), for: .normal)
        leftbtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        let rightbtn = UIButton()
        rightbtn.sizeToFit()
        rightbtn.setImage(#imageLiteral(resourceName: "rightTopImage"), for: .normal)
        rightbtn.addTarget(self, action: #selector(rightbtnclick), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightbtn)
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ofoLogo"))
    }
    @objc func leftbtnclick(){
        
    }
    @objc func rightbtnclick(){
        guard let url = URL(string: "http://m.ofo.so/active.html") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.title = "最新活动"
        self.show(vc, sender: self)
    }
}
