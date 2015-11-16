//
//  WeatherCell.swift
//  MagicWeather
//
//  Created by maiziedu on 11/16/15.
//  Copyright © 2015 Alatan. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    
    @IBOutlet var weekDayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
