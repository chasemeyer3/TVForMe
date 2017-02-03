//
//  EpisodeTableViewCell.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 11/14/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var episode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
