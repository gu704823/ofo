//
//  calayer.swift
//  ofo
//
//  Created by swift on 2017/5/17.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit
extension CALayer {
    //暂停动画
    func pauseAnimation() {
        let pauseTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pauseTime
    }
    //恢复动画
    func resumeAnimation() {
        // 1.取出时间
        let pauseTime = timeOffset
        // 2.设置动画的属性
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        // 3.设置开始动画
        let startTime = convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        beginTime = startTime
    }
}
