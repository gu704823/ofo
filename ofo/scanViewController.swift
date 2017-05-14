//
//  scanViewController.swift
//  ofo
//
//  Created by swift on 2017/5/14.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit
import swiftScan
import FTIndicator
class scanViewController: LBXScanViewController {
    @IBOutlet weak var pannelview: UIView!
    @IBOutlet weak var tourch: UIButton!
    //
    var istourchon = true
    override func viewDidLoad() {
        super.viewDidLoad()
        //导航条
        self.title = "扫码用车"
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //自定义扫描样式
        var scanstyle = LBXScanViewStyle()
        scanstyle.anmiationStyle = .NetGrid
       // scanstyle.
        scanstyle.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line@2x.png")
       scanStyle = scanstyle
        //手电筒
        tourch.addTarget(self, action: #selector(scanViewController.ontourch), for: .touchUpInside)
      
    }
    func ontourch(){
        istourchon = !istourchon
        scanObj?.changeTorch()
        if istourchon{
            tourch.setBackgroundImage(#imageLiteral(resourceName: "btn_unenableTorch_w"), for: .normal)
        }else{
            tourch.setBackgroundImage(#imageLiteral(resourceName: "btn_enableTorch_w"), for: .normal)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubview(toFront: pannelview)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.blue
        
    }

}
