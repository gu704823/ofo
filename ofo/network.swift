//
//  network.swift
//  ofo
//
//  Created by swift on 2017/5/14.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit
import  Alamofire
enum typemethod{
    case get
    case post
}
class network: NSObject {
    class func requestdata(url:String,parameters:[String:String]? = nil,method:typemethod,completion:@escaping (_ result:Any)->()){
        let type = method == typemethod.get ? HTTPMethod.get:HTTPMethod.post
        Alamofire.request(url, method: type, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else{
                print(response.result.error ?? "error")
                return
            }
            completion(result)
        }
    }
}
