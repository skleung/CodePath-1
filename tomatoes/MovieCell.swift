//
//  MovieCell.swift
//  tomatoes
//
//  Created by Sherman Leung on 4/8/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {


  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var synopsisLabel: UILabel!
  @IBOutlet var moviePicture: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
