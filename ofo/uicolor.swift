//
//  uicolor.swift
//  test
//
//  Created by jason on 2017/4/6.
//  Copyright © 2017年 jason. All rights reserved.
//

import UIKit

extension UIColor{
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red: r/256, green: g/256, blue: b/256, alpha: 1.0)
    }
    //主题颜色
    class func Testcolor()->UIColor{
        return UIColor(r: 45, g: 173, b: 244)
    }
    //随机颜色
    class func randomcolor()->UIColor{
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}
