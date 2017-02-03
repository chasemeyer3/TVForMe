//
//  ShowAirtimeCell.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 11/18/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit

class ShowAirtimeCell: UITableViewCell {
    @IBOutlet var airtimeLabel: UILabel!
    @IBOutlet var networkLabel: UILabel!
    @IBOutlet var showNameButton: UIButton!
    @IBOutlet var episodeNameButton: UIButton!
    var tvMazeID:Int?
    var showName:String?
    var genre:String?
    var runtime:Int?
    var premiered:String?
    var time:String?
    var days:String? //make it array
    var rating:Int?
    var showDescription:String?
}