//
//  TableViewCell.swift
//  Weather
//
//  Created by Riddhi Gajjar on 9/6/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var cityName: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var tempmaxLabel: UILabel!
    @IBOutlet var tempminLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        contentView.layer.cornerRadius = 8.0
    }
    
    
}
