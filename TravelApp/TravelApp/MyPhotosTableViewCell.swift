//
//  MyPhotosTableViewCell.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/19/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import UIKit

class MyPhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var postDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
