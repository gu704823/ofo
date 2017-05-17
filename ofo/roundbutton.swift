//
//  roundbutton.swift
//  ofo
//
//  Created by swift on 2017/5/17.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit

class roundbutton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //设置button的圆角
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2
        //buttond的边距大小和颜色
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).cgColor
    
    }
    //buttonde 转动
    func onrotation(){
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 20
        animation.repeatCount = MAXFLOAT
        self.layer.add(animation, forKey: "heihei")
    }
    func pause(){
        self.layer.removeAllAnimations()
    }
}
