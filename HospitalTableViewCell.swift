//
//  HospitalTableViewCell.swift
//  VacCalc
//
//  Created by Sumrudhi Jadhav on 11/22/20.
//  Copyright © 2020 CATS. All rights reserved.
//

import UIKit

class HospitalTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
