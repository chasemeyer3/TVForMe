//
//  ShowCollectionViewCell.swift
//  recommended
//
//  Created by Meyer, Chase R on 11/14/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit

class ShowCollectionViewCell: UICollectionViewCell {
    @IBOutlet var showArt: UIImageView!
    @IBOutlet var showName: UILabel!
    @IBOutlet var showGenre: UILabel!
    var imageLink:String?
    var showDescription:String?
    var showID:Int?
    var showRating:String?
    var releasedDate:String?
    
    var markedForDeletion = false
}
