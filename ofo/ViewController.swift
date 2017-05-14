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
import FTIndicator
class  ViewController: UIViewController {
    ///拖
    @IBAction func locationbtntap(_ sender: UIButton) {
        userlocation()
        searchnearbybike()
    }
    
    //定义属性
    var mapview:MAMapView!
    var search:AMapSearchAPI!
    var annotations:[MAPointAnnotation] = []
    var pin:mypinannotation!
    var pinview:MAPinAnnotationView!
    var nearbystate:Bool = true
    var start,end: CLLocationCoordinate2D!
    var walkmanger:AMapNaviWalkManager!
    var driveview:AMapNaviDriveView!
    var drivemanger:AMapNaviDriveManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置ui
        setupui()
        //自定义地位点图标样式
        userlocation()
    }
}
extension ViewController:MAMapViewDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate{
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
        mapview.delegate  = self
        view.insertSubview(mapview, at:0 )
        //初始化高德地图搜索
        search = AMapSearchAPI()
        search.delegate = self
        //步行导航
        walkmanger = AMapNaviWalkManager()
        walkmanger.delegate = self
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
//        let r = MAUserLocationRepresentation()
//        r.showsAccuracyRing = true
//        r.showsHeadingIndicator = true
//        r.fillColor = UIColor.red
//        r.lineWidth = 6
//        r.enablePulseAnnimation = true
//        r.locationDotBgColor = UIColor.blue
//        r.locationDotFillColor = UIColor.orange
//       // r.image = uii
//        mapview.update(r)
    }
    //周边检索
    func searchnearbybike(){
        nearbystate = true
        searchcustomlocation(mapview.userLocation.coordinate)
    }
    func searchcustomlocation(_ center:CLLocationCoordinate2D){
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
            print("周边没有")
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
        //nearbystate为true,
        if nearbystate{
            mapview.showAnnotations(annotations, animated: true)
            nearbystate = !nearbystate
        }
    }
    //大头针视图修改
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        //排除用户定位图标
        if annotation is MAUserLocation {
            return nil
        }
        //排除自定义大头针
        if annotation is mypinannotation {
            let pointreuseindetifiter = "anchor"
            var annotationview = mapview.dequeueReusableAnnotationView(withIdentifier: pointreuseindetifiter) as? MAPinAnnotationView
            if annotationview == nil{
                annotationview = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointreuseindetifiter)
            }
            annotationview?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            annotationview?.canShowCallout = true
            annotationview?.animatesDrop = true
            pinview = annotationview
            return annotationview
        }
        //大头针视图修改
            let pointreuseindetifiter = "pointReuseIndetifier"
            var annotationview = mapview.dequeueReusableAnnotationView(withIdentifier: pointreuseindetifiter) as? MAPinAnnotationView
            if annotationview == nil{
                annotationview = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointreuseindetifiter)
            }
            if annotation.title == "红包区域内开启任意小黄车"{
                annotationview?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket")
            }else{
                annotationview?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        }
        
            annotationview?.canShowCallout = true
            annotationview?.animatesDrop = true
            return annotationview
    }
    //点击了大头针的动作
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        start = mapview.userLocation.coordinate
        end = view.annotation.coordinate
        let startpoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))
        let endpoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))
        walkmanger.calculateWalkRoute(withStart: [startpoint!], end: [endpoint!])
    }
    //处理步行处理结果
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        //去除地图上得线
        mapview.removeOverlays(mapview.overlays)
        var coordinates = walkmanger.naviRoute!.routeCoordinates.map{
            return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
        }
        //绘线
        let polyline:MAPolyline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapview.add(polyline)
        //提示距离和用时
        let walkminiutes = (walkmanger.naviRoute!.routeTime)/60
        var timedesc = "1分钟以内"
        if walkminiutes>1{
            timedesc = walkminiutes.description + "分钟"
        }
        let hittitle = "步行" + timedesc
        let hintsubtile = "距离" + walkmanger.naviRoute!.routeLength.description + "米"
        FTIndicator.setIndicatorStyle(.dark)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: hittitle, message: hintsubtile)
       
        
    }
    //绘线的回调
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self){
            mapview.visibleMapRect = overlay.boundingMapRect
            let renderer:MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 5.0
            renderer.strokeColor = UIColor.orange
            return renderer
        }
        return nil
    }
    
    //自定义大头针的动画
    func pinanimation(){
        let endframe = pinview.frame
        pinview.frame = pinview.frame.offsetBy(dx: 0, dy: -50)
       UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: { 
        self.pinview.frame = endframe
       }, completion: nil)
    }
    //地图初始化完成后
    func mapInitComplete(_ mapView: MAMapView!) {
          pin = mypinannotation()
        pin.coordinate = mapview.centerCoordinate
        pin.lockedScreenPoint = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        pin.isLockedToScreen = true
        mapview.addAnnotation(pin)
        mapview.showAnnotations([pin], animated: true)
        searchnearbybike()
    }
    //用户是否移动
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction {
            mapview.removeAnnotations(annotations)
            pin.isLockedToScreen = true
            pinanimation()
            searchcustomlocation(mapview.centerCoordinate)
        }
    }
    //
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aviews = views as! [MAAnnotationView]
        for aview in aviews{
            guard aview.annotation is MAPointAnnotation else {
                continue
            }
            aview.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
                aview.transform = .identity
            }, completion: nil)
        }
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
    
    @objc func rightbtnclick(){
        guard let url = URL(string: "http://www.huya.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.title = "最新活动"
        self.show(vc, sender: self)
    }
}
