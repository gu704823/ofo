//
//  songlistTableViewCell.swift
//  ofo
//
//  Created by swift on 2017/5/15.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit

class songlistTableViewCell: UITableViewCell {
    @IBOutlet weak var author: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var singer: UILabel!
    @IBOutlet weak var time: UILabel!

    @IBOutlet weak var currentime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       author.layer.cornerRadius = author.frame.width/2
       author.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
