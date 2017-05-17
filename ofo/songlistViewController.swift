//
//  songlistViewController.swift
//  ofo
//
//  Created by swift on 2017/5/15.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit
import  SwiftyJSON
import Kingfisher
import AVFoundation

class songlistViewController: UIViewController {
//拖
    @IBOutlet weak var songlist: UITableView!
    @IBOutlet weak var albumimg: UIImageView!
    @IBOutlet weak var songpic: UIButton!
    @IBOutlet weak var songname: UILabel!
    @IBOutlet weak var artist: UILabel!
   
   
    
    
 //定义属性
    var songmodel:httpmodel = httpmodel()
    var songdict:[[String:JSON]] = []
    var id:JSON = 0
    var avplayer = AVPlayer()
    var albumdict:[String:JSON]?{
        didSet{
            guard let urlrequest = albumdict?["albumimg"] else {
                return
            }
            let url = URL(string: "\(urlrequest)")
            albumimg.kf.setImage(with: url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupui()
        loaddata()
    }

}
//ui
extension songlistViewController{
    fileprivate func setupui(){
        //1.修改导航条样式
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        let customFont = UIFont(name: "heiti SC", size: 12.0)!
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName:customFont], for: .normal)
        //tableview数据源代理
        songlist.delegate = self
        songlist.dataSource = self
        //
       
        
    }
}
//tableview
extension songlistViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songdict.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songlist", for: indexPath) as! songlistTableViewCell
        let urladdr = songdict[indexPath.row]["pict"]
        let url = URL(string: "\(urladdr!)")
        cell.author.kf.setImage(with:url )
        cell.singer.text = "\(songdict[indexPath.row]["author"]!)"
        cell.title.text = "\(songdict[indexPath.row]["title"]!)"
        let timedurtation = Int(songdict[indexPath.row]["file_duration"]! .stringValue)
        cell.time.text = lengthtime.length(all: timedurtation!)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}
//loaddata
extension songlistViewController{
    fileprivate func loaddata(){
        songmodel.onsearhlist(type: "\(id)") { ( data1, data2) in

            self.songdict = data2
            self.albumdict = data1
            self.songlist.reloadData()
        }
        
    }
}
//处理逻辑
extension songlistViewController{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songid = songdict[indexPath.row]["songid"]!
        songmodel.getmusicdata(songid: "\(songid)") { (filelink) in
            let url = URL(string: "\(filelink)")
            self.avplayer = AVPlayer(url: url!)
            self.avplayer.play()
        }
        songname.text = "\(songdict[indexPath.row]["title"]!)"
        artist.text = "\(songdict[indexPath.row]["author"]!)"
        let urladdr = songdict[indexPath.row]["pict"]
        guard let songpicurl = URL(string: "\(urladdr!)") else {
            return
        }
         songpic.kf.setImage(with: songpicurl, for: .normal)
    }
}
