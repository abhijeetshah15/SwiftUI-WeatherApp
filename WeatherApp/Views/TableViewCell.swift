//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Abhijeet Shah on 2/14/22.
//

import UIKit
import CoreLocation

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var skyConditionLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
