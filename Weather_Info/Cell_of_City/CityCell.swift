//
//  CityCell.swift
//  Weather_Info
//
//  Created by Ahmad Hussain Zamee on 11/9/19.
//  Copyright © 2019 Ahmad Hussain Zamee. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemparature: UILabel!
    @IBOutlet weak var cityWeatherImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
