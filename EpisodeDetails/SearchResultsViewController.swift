//
//  ViewController.swift
//  apiexample
//
//  Created by Meyer, Chase R on 11/7/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit



class SearchResultsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    var showName = ""
    var tvShow:[String:JSON]!
    var total = 0
    var returnedShows:JSON!
    var searchReceived = ""
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        
        if(!searchReceived.isEmpty){
            populateTable(searchReceived)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //obtain the search terms and populate the table
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        populateTable(searchBar.text!)
        
    }
    
    //get json from the search
    func populateTable(search: String){
        let updatedSearch = search.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let url = NSURL(string: "https://api.themoviedb.org/3/search/tv?api_key=82bf1c5f02fa122f8de61e355a180c6e&language=en-US&query=\(updatedSearch)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            self.returnedShows = JSON(data: data!)["results"]
            self.total = self.returnedShows.count //to make the table cells be able to load and reload
            //reload table data after receiving the info
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    
    //update the table cells witht the info
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        let rating = returnedShows![indexPath.row]["vote_average"]
        if(rating != nil){
            cell.rating.text = "\(rating.double!)"
        }else{
            cell.rating.text = "No Rating Available"
        }
        //get image from URL
        let urlString = returnedShows![indexPath.row]["poster_path"]
        if  urlString != nil {
            let url = NSURL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2\(urlString.string!)")
            if let data = NSData(contentsOfURL: url!) {
                dispatch_async(dispatch_get_main_queue()) {
                    cell.showImage.image = UIImage(data: data)
                    
                }
            }
        }
        
        
        cell.showDesc.text = returnedShows![indexPath.row]["overview"].string
        cell.showName.text = returnedShows![indexPath.row]["name"].string
        cell.showImage.image = UIImage(named: "no show art") //need something for when the image is not available
        cell.showRelease.text = returnedShows![indexPath.row]["first_air_date"].string
        
        // Configure the cell...
        
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print((totalReturnedShows.count))
        return total
    }
    
    //to transfer the info from the cell into the Quest View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier ==  "tvShowSegue"){
            let viewController = segue.destinationViewController as! TVShowsViewController
            let selectedCell = sender as? TableViewCell
            viewController.showID = returnedShows![tableView.indexPathForSelectedRow!.row]["id"].int
            viewController.tvShowImage = selectedCell!.showImage.image
            viewController.released = selectedCell!.showRelease.text
            viewController.tvShowRating = selectedCell!.rating.text
            viewController.tvShowDescription = selectedCell!.showDesc.text
            viewController.tvShowName = selectedCell!.showName.text
        }
    }
    
    
}

