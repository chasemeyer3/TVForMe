//
//  ShowCollectionView.swift
//  recommended
//
//  Created by Meyer, Chase R on 11/13/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit
import CoreData

class RecommendedTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: Variables
    let categories = ["What's On Tonight?", "Popular", "Recommended for You!"]
    
    var onTonight = [(json: JSON, image: NSData)]()
    var popular = [(json: JSON, image: NSData)]()
    var recommendedShowJSONs: [(json: JSON, image: NSData)]?  // To be received from segue
    
    
    // MARK: Dumb functions all classes need
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getOnTonight()
        getPopular()
        // NB. "Recommended for You!" info is received from Dashboard segue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Pull data from API with which to populate UICollectionViews
    
    func getOnTonight() {
        let url = NSURL(string: "https://api.themoviedb.org/3/tv/airing_today?api_key=82bf1c5f02fa122f8de61e355a180c6e&language=en-US")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let jsonResults = JSON(data: data!)["results"]
            
            for result in jsonResults {
                let show = result.1
                self.setShowAndImage(show, appendTo: "onTonight")
            }
        }
        task.resume()
    }
    
    func getPopular() {
        let url = NSURL(string: "https://api.themoviedb.org/3/discover/tv?api_key=82bf1c5f02fa122f8de61e355a180c6e&language=en-US&sort_by=popularity.desc&page=1&timezone=America/Austin&include_null_first_air_dates=false")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let jsonResults = JSON(data: data!)["results"]
            
            for result in jsonResults {
                let show = result.1
                self.setShowAndImage(show, appendTo: "popular")
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func setShowAndImage(show: JSON, appendTo: String) {
        let urlString = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/\(show["poster_path"])"
        let url = NSURL(string: urlString)
        if let data = NSData(contentsOfURL: url!) {
            dispatch_async(dispatch_get_main_queue()) {
                if appendTo == "onTonight" {
                    self.onTonight.append((json: show, image: data))
                    (self.tableView.visibleCells[0] as! RecommendedCategoryCell).showCollectionView.reloadData()
                } else if appendTo == "popular" {
                    self.popular.append((json: show, image: data))
                    (self.tableView.visibleCells[1] as! RecommendedCategoryCell).showCollectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Skip "Recommended" category if there are no shows to recommend (will happen if user hasn't added any shows)
        if recommendedShowJSONs!.count == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecommendedCategory") as! RecommendedCategoryCell
        cell.categoryNameLabel.text = categories[indexPath.row]
        cell.showCollectionView.tag = indexPath.row
        
        // Only reveal "Show More" button for What's On Tonight category
        if indexPath.row != 0 {
            cell.showMoreButton.hidden = true
        }
        
        return cell
    }
    
    // MARK: Collection Views
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return onTonight.count
        } else if collectionView.tag == 1 {
            return popular.count
        } else {
            return recommendedShowJSONs!.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let showCell = collectionView.dequeueReusableCellWithReuseIdentifier("ShowCollectionViewCell", forIndexPath: indexPath) as! ShowCollectionViewCell
        
        // Populate What's On Tonight collectionView
        if collectionView.tag == 0 {
            let show = onTonight[indexPath.row].json
            
            showCell.showName.text = show["name"].string
            showCell.showDescription = show["overview"].string
            showCell.releasedDate = show["first_air_date"].string
            showCell.showID = show["id"].int
            let rating = show["vote_average"]
            if(rating != nil){
                showCell.showRating = "\(rating.double!)"
            }else{
                showCell.showRating = "No Rating Available"
            }

            
            if show["genre_ids"].array! != [] {
                showCell.showGenre.text = ConvertGenreIDToGenre(show["genre_ids"].array![0].int!)
            } else {
                showCell.showGenre.text = "N/A"
            }
            
            if self.onTonight.count != 0 {
                showCell.showArt.image = UIImage(data: self.onTonight[indexPath.row].image)
            }
            
            // Populate Popular collectionView
        } else if collectionView.tag == 1 {
            let show = popular[indexPath.row].json
            
            showCell.showName.text = show["name"].string
            showCell.showGenre.text = String(show["genre_ids"].array![0].int!)
            showCell.showDescription = show["overview"].string
            showCell.releasedDate = show["first_air_date"].string
            showCell.showID = show["id"].int!
            let rating = show["vote_average"]
            if(rating != nil){
                showCell.showRating = "\(rating.double!)"
            }else{
                showCell.showRating = "No Rating Available"
            }
            
            if show["genre_ids"].array! != [] {
                showCell.showGenre.text = ConvertGenreIDToGenre(show["genre_ids"].array![0].int!)
            } else {
                showCell.showGenre.text = "N/A"
            }
            
            if self.popular.count != 0 {
                showCell.showArt.image = UIImage(data: self.popular[indexPath.row].image)
            }
            
            
            // Populate Recommended collectionView
        } else {
            let show = recommendedShowJSONs![indexPath.row].json
            showCell.showName.text = show["name"].string
            showCell.showGenre.text = show["genres"].array![0]["name"].string
            //showCell.showGenre.text = String(show["genre_ids"].array![0].int!)
            showCell.showDescription = show["overview"].string
            showCell.releasedDate = show["first_air_date"].string
            showCell.showID = show["id"].int!
            let rating = show["vote_average"]
            if(rating != nil){
                showCell.showRating = "\(rating.double!)"
            }else{
                showCell.showRating = "No Rating Available"
            }
            
            if self.recommendedShowJSONs!.count != 0 {
                showCell.showArt.image = UIImage(data: self.recommendedShowJSONs![indexPath.row].image)
            }
        }
        
        return showCell
    }
    
    //to transfer the info from the cell into the shows View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier ==  "recommendedToShow"){
            let viewController = segue.destinationViewController as! TVShowsViewController
            let selectedCell = sender as? ShowCollectionViewCell
            viewController.showID = selectedCell?.showID
            viewController.tvShowImage = selectedCell!.showArt.image
            viewController.released = selectedCell?.releasedDate
            viewController.tvShowRating = selectedCell?.showRating
            viewController.tvShowDescription = selectedCell?.showDescription
            viewController.tvShowName = selectedCell!.showName.text
           // print(selectedCell?.imageLink)
            //viewController.imageLink = (selectedCell?.imageLink)!
        }
    }

    
    
}