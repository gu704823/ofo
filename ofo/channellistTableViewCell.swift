//
//  channellistTableViewCell.swift
//  ofo
//
//  Created by AirBook on 2017/5/16.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit

class channellistTableViewCell: UITableViewCell {
    @IBOutlet weak var channelimg: UIImageView!

    @IBOutlet weak var channellist: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
