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
//        cell.channellist.text = "\(listdata[indexPath.row]["name"]!)"
//        let urladdr = listdata[indexPath.row]["albumimg"]
//        let url = URL(string: "\(urladdr!)")
//        cell.channelimg.kf.setImage(with:url )
        return cell
    }
    
}
//loaddata
extension arangTableViewController{
    fileprivate func lodadata(){
       datamodel.onsearchtotalchannel { (result) in
        self.listdata = result
        self.tableView.reloadData()
        }
    }
}


// MARK: - Table view data source

/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
