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
    @IBOutlet weak var progres: UIImageView!
    
    @IBOutlet weak var songpic: roundbutton!
    @IBOutlet weak var songname: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var playpause: UIButton!
    @IBOutlet weak var currenttime: UILabel!
    @IBOutlet weak var totaltime: UILabel!
    @IBOutlet weak var nextbutton: UIButton!
   
    
    
 //定义属性
    var songmodel:httpmodel = httpmodel()
    var songdict:[[String:JSON]] = []
    var id:JSON = 0
    var albumdict:[String:JSON]?{
        didSet{
            guard let urlrequest = albumdict?["albumimg"] else {
                return
            }
            let url = URL(string: "\(urlrequest)")
            albumimg.kf.setImage(with: url)
        }
    }
    var avplayer = AVPlayer()
    var isplay:Bool = true
    var timer:Timer?
    var  index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupui()
        loaddata()
        threebutton()
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
        guard  let timedurtation = Int(songdict[indexPath.row]["file_duration"]! .stringValue) else{
            return cell
        }
        cell.time.text = lengthtime.length(all: timedurtation)
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
//点击cell处理逻辑
extension songlistViewController{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        onselectrow(index: indexPath.row)
        
        
        
    }
    func onselectrow(index:Int){
        let indexpatch = IndexPath(item: index, section: 0)
        songlist.selectRow(at: indexpatch, animated: true, scrollPosition: .top)
        songname.text = "\(songdict[indexpatch.row]["title"]!)"
        artist.text = "\(songdict[indexpatch.row]["author"]!)"
        let urladdr = songdict[indexpatch.row]["pict"]
        guard let songpicurl = URL(string: "\(urladdr!)") else {
            return
        }
        songpic.kf.setImage(with: songpicurl, for: .normal)
        songpic.onrotation()
        let songid = songdict[indexpatch.row]["songid"]!
        songmodel.getmusicdata(songid: "\(songid)") { (filelink) in
            self.onplaymusic(filelinkurl: "\(filelink)")
        }
        //时间
        timer?.invalidate()
        currenttime.text = "00:00"
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(onupdate), userInfo: nil, repeats: true)
    }
    func onplaymusic(filelinkurl:String){
        let url = URL(string: filelinkurl)
        self.avplayer = AVPlayer(url: url!)
        self.avplayer.play()
    }
//最下面三个按钮的方法
    fileprivate func threebutton(){
        playpause.addTarget(self, action: #selector(play), for: .touchUpInside)
        nextbutton.addTarget(self, action: #selector(nextmusic), for: .touchUpInside)
        
    }
}
extension songlistViewController{
    //更新时间方法
    @objc fileprivate func onupdate(){
        let currenttimer = CMTimeGetSeconds(self.avplayer.currentTime())
        let totaltimer = TimeInterval((avplayer.currentItem?.duration.value)!)/TimeInterval((avplayer.currentItem?.duration.timescale)!)
        let progr = CGFloat(currenttimer/totaltimer)
        if currenttimer>0.0{
            currenttime.text = lengthtime.length(all: Int(currenttimer))
            totaltime.text = lengthtime.length(all: Int(totaltimer))
            self.progres.frame.size.width = view.frame.size.width * progr
            
        }
    }
     @objc fileprivate func play(){
        if isplay{
            avplayer.pause()
            playpause.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
            isplay = !isplay
            songpic.pause()
        }else{
            avplayer.play()
            playpause.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
            isplay = !isplay
            songpic.onrotation()
        }
    }
    @objc fileprivate func nextmusic(btn:UIButton){
        if btn == nextbutton{
            index += 1
            if index>self.songdict.count - 1{
             index = 0
            }
        }
        onselectrow(index: index)
        playpause.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
        isplay = !isplay
    }
}
