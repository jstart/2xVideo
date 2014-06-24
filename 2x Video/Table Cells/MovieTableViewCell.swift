//
//  MovieTableViewCell.swift
//  2x Video
//
//  Created by Christopher Truman on 6/11/14.
//  Copyright (c) 2014 Truman. All rights reserved.
//

import UIKit
import MediaPlayer

class MovieTableViewCell: UITableViewCell {
	
	@IBOutlet var backgroundImageView : UIImageView
	@IBOutlet var overlayLabel : UILabel
	
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
