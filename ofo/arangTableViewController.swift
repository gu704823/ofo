//
//  arangTableViewController.swift
//  ofo
//
//  Created by swift on 2017/5/14.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit
import SwiftyJSON
class arangTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupui()
        lodadata()
    }
//拖
//定义属性
    let datamodel:httpmodel = httpmodel()
    var listdata:[[String:JSON]] = []
    
}
//setupui
extension arangTableViewController{
    fileprivate func setupui(){
        self.title = "频道列表"
    }
    
}
//tableview
extension arangTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listdata.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listcellid", for: indexPath) as! channellistTableViewCell
        
        cell.channellist.text = "\(listdata[indexPath.row]["name"]!)"
        cell.id.text = "\(listdata[indexPath.row]["id"]!)"
        
        let urladdr = listdata[indexPath.row]["albumimg"]
        let url = URL(string: "\(urladdr!)")
        cell.channelimg.kf.setImage(with:url )
        return cell
    }
}
//loaddata
extension arangTableViewController{
    fileprivate func lodadata(){
      datamodel.onsearchtotalchannel { (data) in
        self.listdata = data
        self.tableView.reloadData()
        }
    }
}
//转场
extension arangTableViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            if let indexpatch = self.tableView.indexPathForSelectedRow{
              let controller = segue.destination as! songlistViewController
                controller.id = listdata[indexpatch.row]["id"]!
            }
            
           
        }
    }
}



