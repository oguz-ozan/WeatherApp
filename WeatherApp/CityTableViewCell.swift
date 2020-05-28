//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Oğuz Özan on 28.05.2020.
//  Copyright © 2020 Oğuz Özan. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherStatusLabel: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var celsiusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
