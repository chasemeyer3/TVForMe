//
//  TableViewCell.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 11/13/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var showDesc: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var totalSeasons: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showRelease: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
