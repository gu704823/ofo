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
class ViewController: UIViewController {
    
    //定义属性
    var mapview = MAMapView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置ui
        setupui()
    }
}
extension ViewController{
    fileprivate func setupui(){
        //设置导航条
        setupnavi()
        //侧边栏
        if self.revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 280
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //高德地图
        mapview.frame  = self.view.bounds
        view.insertSubview(mapview, at:0 )
    }
}
//导航
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
