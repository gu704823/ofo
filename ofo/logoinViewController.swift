//
//  logoinViewController.swift
//  test
//
//  Created by jason on 2017/4/11.
//  Copyright © 2017年 jason. All rights reserved.
//

import UIKit
import JSAnimatedImagesView
import LeanCloud


class logoinViewController: UIViewController {
    //定义属性
    fileprivate let wallerpapers:[UIImage] = [#imageLiteral(resourceName: "wallerpaper1"),#imageLiteral(resourceName: "wallerpaper2"),#imageLiteral(resourceName: "wallerpaper3")]
    
    @IBOutlet weak var wallerpaper: JSAnimatedImagesView!
    @IBOutlet weak var headimage: UIImageView!
    @IBOutlet weak var ID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var alpha: UIImageView!
    @IBAction func register(_ sender: UIButton) {
    }
    @IBAction func forgetpassword(_ sender: UIButton) {
    }
    fileprivate lazy var faliure:UILabel = {
        let label = UILabel(frame: CGRect(x: 0.5*kscreenw, y: -0.1*kscreenh, width: 0.3*kscreenw, height: 0.1*kscreenw))
        label.text = "登录失败"
        label.textAlignment = .center
        label.backgroundColor = UIColor.Testcolor()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.textColor = UIColor.red
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(faliure)
     //设置ui
        setupui()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {       
    }
}
//设置ui
extension logoinViewController{
    fileprivate func setupui(){
    //登录按钮实现逻辑
    logout.addTarget(self, action:#selector(logoutbutton), for: .touchUpInside)
        
    //数据源
    self.wallerpaper.dataSource = self
    }
}
//wallerpaper的数据源
extension logoinViewController:JSAnimatedImagesViewDataSource{
    func animatedImagesNumber(ofImages animatedImagesView: JSAnimatedImagesView!) -> UInt {
        return UInt(self.wallerpapers.count)
    }
    func animatedImagesView(_ animatedImagesView: JSAnimatedImagesView!, imageAt index: UInt) -> UIImage! {
        return UIImage(named: "wallerpaper\(index + 1)")
    }
}
extension logoinViewController{
 @objc fileprivate func logoutbutton(){
        //登录
        guard  let ID = ID.text else {
            return
        }
        guard  let password = password.text else {
            return
        }
        let logname = LCQuery(className: "users")
        logname.whereKey("name", .equalTo(ID))
        let logpassword = LCQuery(className: "users")
        logpassword.whereKey("password", .equalTo(password))
        let query = logname.and(logpassword)
        query.getFirst { (result) in
            switch result{
            case.success(object: _):
                self.faliure.text = "登录成功"
                
            case.failure(error: _):
                self.faliure.text = "登录失败"

            }
            //3.设定关键帧
            let keyAnimate = CAKeyframeAnimation(keyPath: "position")
            let keyopacity = CAKeyframeAnimation(keyPath: "opacity")
            let value0 = NSValue(cgPoint: CGPoint(x: 0.5*kscreenw, y: -0.05*kscreenw))
            let value1 = NSValue(cgPoint: CGPoint(x: 0.5*kscreenw, y: 0.75*kscreenh))
            let value2 = NSValue(cgPoint: CGPoint(x: 0.5*kscreenw, y: 0.73*kscreenh))
            let value3 = NSValue(cgPoint: CGPoint(x: 0.5*kscreenw, y: 0.75*kscreenh))
            let value4 = NSValue(cgPoint: CGPoint(x: 0.5*kscreenw, y: 0.74*kscreenh))
            let value5 = NSValue(cgPoint: CGPoint(x: 0.5*kscreenw, y: 0.75*kscreenh))
            let value6 = NSValue(cgPoint: CGPoint(x: 0.5*kscreenw, y: 0.75*kscreenh))
            let value7 = NSValue(cgPoint: CGPoint(x: 0.5*kscreenw, y: 1.1*kscreenh))
            keyAnimate.values = [value0, value1, value2, value3, value4,value5,value6,value7]
            keyAnimate.autoreverses = false
            keyAnimate.duration = 5.0
            keyopacity.values = [0,1,0.9,1,0.95,1,1,0]
            keyopacity.autoreverses = false
            keyopacity.duration = 5.0
            self.faliure.layer.add(keyAnimate, forKey: "keyAnimate")
            self.faliure.layer.add(keyopacity, forKey: "keyopacity")
            
            //                let scale = POPSpringAnimation(propertyNamed:kPOPViewScaleXY)
            //                scale?.toValue = NSValue(cgPoint: CGPoint(x: 0.5, y: 0.5))
            //                scale?.springBounciness = 4
            //                scale?.springSpeed = 1
            //                self.logout.pop_add(scale, forKey: "scale")
        }
    }
}
