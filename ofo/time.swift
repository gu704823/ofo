//
//  time.swift
//  music
//
//  Created by jason on 2017/4/22.
//  Copyright © 2017年 jason. All rights reserved.
//

import UIKit

class lengthtime {
    class func length(all:Int)->(String){
        var minute:String?
        let m:Int = all % 60
        if m<10{
            minute = "0\(m)"
        }else{
            minute = "\(m)"
        }
        let s:Int = all/60
        let lengthtime:String = "0\(s):\(minute!)"
        return lengthtime
    }
}
