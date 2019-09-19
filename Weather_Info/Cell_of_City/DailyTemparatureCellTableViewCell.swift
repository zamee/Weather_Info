//
//  DailyTemparatureCellTableViewCell.swift
//  Weather_Info
//
//  Created by Ahmad Hussain Zamee on 17/9/19.
//  Copyright © 2019 Ahmad Hussain Zamee. All rights reserved.
//

import UIKit

class DailyTemparatureCellTableViewCell: UITableViewCell {

    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var dailyMinTemp: UILabel!
    @IBOutlet weak var dailyMaxTemp: UILabel!
    @IBOutlet weak var dailyTempImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
