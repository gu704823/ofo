//
//  httpmodel.swift
//  ofo
//
//  Created by swift on 2017/5/14.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit
import SwiftyJSON
class httpmodel: NSObject {
    //定义属性
    let url = "http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music"
    //电台列表
    func onsearhlist(){
        let parameters = ["method":"baidu.ting.billboard.billList","type":"1","size":"10","offset":"0"]
        network.requestdata(url: url, parameters: parameters, method: .get) { (result) in
            let json = JSON(result)
            
        }
    }
}
/*
 http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.billboard.billList&type=1&size=10&offset=0
 
 http://tingapi.ting.baidu.com/v1/restserver/ting
 一、获取列表
 format=json或xml&calback=&from=webapp_music&method=
 method=baidu.ting.billboard.billList&type=1&size=10&offset=0
 参数：	type = 1-新歌榜,2-热歌榜,11-摇滚榜,12-爵士,16-流行,21-欧美金曲榜,22-经典老歌榜,23-情歌对唱榜,24-影视金曲榜,25-网络歌曲榜
 size = 10 //返回条目数量
 offset = 0 //获取偏移
 三、搜索
 method=baidu.ting.search.catalogSug&query=海阔天空
 四、播放
 method=baidu.ting.song.play&songid=877578
 method=baidu.ting.song.playAAC&songid=877578
 五、LRC歌词
 method=baidu.ting.song.lry&songid=877578
 六、推荐列表
 method=baidu.ting.song.getRecommandSongList&song_id=877578&num=5
 七、下载
 method=baidu.ting.song.downWeb&songid=877578&bit=24&_t=1393123213
 八、获取歌手信息
 
 例：method=baidu.ting.artist.getInfo&tinguid=877578
 
 九、获取歌手歌曲列表
 
 method=baidu.ting.artist.getSongList&tinguid=877578&limits=6&use_cluster=1&order=2
 */
