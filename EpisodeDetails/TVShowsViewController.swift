//
//  ShowsViewController.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 11/14/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit
import CoreData
//import SwiftyJSON

class TVShowsViewController: UIViewController, UITableViewDataSource {
    let total = 0
    
    var seasonNumEpi:[(seasonNumber: Int, totalNumEpisodes: Int)] = []
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet var imageShow: UIImageView!
    @IBOutlet var showName: UILabel!
    @IBOutlet var showDescription: UILabel!
    @IBOutlet var totalSeasons: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var airInfo: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var seasonsTableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    var released:String?
    var tvShowImage:UIImage?
    var tvShowName:String?
    var tvShowRating:String?
    var tvShowDescription:String?
    var showID:Int!
    var genresArray:[(genreID: Int, genreName: String)] = []
    var tvDBID:Int!
    var dictionaryShow =  Dictionary<String, Any>()
    var tvDBShowInfo:JSON!
    //var seasonNumEpi:[(seasonNumber: Int, totalNumEpisodes: Int)] = []
    var shows = [NSManagedObject]()
    var showIDsToRecommend = [Int]()
    var tvMazeID:Int!
    var network = ""
    var imageLink = ""
    var fromOnTonight = false
    var day:String?
    var time: String?
    var nextEpisodeLink:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showName.text = tvShowName
        if tvShowRating == "nil"{
            ratingLabel.text = "Rating N/A"
        }else{
            ratingLabel.text = tvShowRating
        }
        
        
        showDescription.text = tvShowDescription
        if !fromOnTonight{
            imageShow.image = tvShowImage
            getShowInfo()
            getOtherIDs()
            checkIfShowAdded()
            getVideo()
        }else{
            //update all the info using the name of the tv show from tvmaze into moviedb
            print(tvShowName)
            let updatedSearch = tvShowName!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let url = NSURL(string: "https://api.themoviedb.org/3/search/tv?api_key=82bf1c5f02fa122f8de61e355a180c6e&language=en-US&query=\(updatedSearch)")
            if(url != nil){
                let request = NSURLRequest(URL: url!)
                let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    
                    let show = JSON(data: data!)["results"]
                    dispatch_async(dispatch_get_main_queue()) {
                        if show.count == 1 {
                            self.showID = show[0]["id"].int
                            self.showDescription.text = show[0]["overview"].string
                            self.getShowInfo()
                            self.checkIfShowAdded()
                            self.getVideo()
                            let urlString = show[0]["poster_path"]
                            if  urlString != nil {
                                let url = NSURL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2\(urlString.string!)")
                                if let data = NSData(contentsOfURL: url!) {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        //self.imageURL =  urlString.string!
                                        self.imageLink = urlString.string!
                                        self.imageShow.image = UIImage(data: data)
                                    }
                                }
                            }
                            
                        }else{
                            //do not let them add the show
                            self.button.enabled = false
                            print("cant find the correct show")
                        }
                    }
                }
                task.resume()
            }
            print(time, day)
            if (time != nil && day != nil){
                self.airInfo.text = "\(day!)s at \(time!)"
            }else{
                self.airInfo.text = "Not Available"
            }
            
        }
        
       
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return seasonNumEpi.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SeasonsTableViewCell", forIndexPath: indexPath) as! SeasonsTableViewCell
        
        cell.seasons.text = "Season \(seasonNumEpi[indexPath.row].seasonNumber)"
        //print("\(indexPath.row)")
        return cell
    }
    
    
    //check if show is added to coredata
    func checkIfShowAdded() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        var userInfo = [NSManagedObject]()
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            userInfo = results as! [NSManagedObject]
        } catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        let info = userInfo[0].valueForKey("favoriteShows") as! [Int]
        
        if info.contains(showID) {
            button.enabled = false
        }else{
            print("why you not hide")
        }
        
    }

    
    func getOtherIDs(){
        let url = NSURL(string: "https://api.themoviedb.org/3/tv/\(showID)/external_ids?api_key=82bf1c5f02fa122f8de61e355a180c6e&language=en-US")
        print(url)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            //self.tvDBID = JSON(data: data!)["tvdb_id"].int
            let otherIDs = JSON(data: data!)
            self.tvDBID = otherIDs["tvdb_id"].int
           // print("inside othersid" , self.tvMazeID)
            //get airing time info for the tv show
            
            dispatch_async(dispatch_get_main_queue()) {
                let url = NSURL(string: "http://api.tvmaze.com/lookup/shows?thetvdb=\(self.tvDBID)")
                let request = NSURLRequest(URL: url!)
                let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    self.tvDBShowInfo = JSON(data: data!)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tvMazeID = self.tvDBShowInfo["id"].int
                        let day = self.tvDBShowInfo["schedule"]["days"][0].string
                        let time = self.tvDBShowInfo["schedule"]["time"].string
                        if (time != nil && day != nil){
                            self.airInfo.text = "\(day!)s at \(time!)"
                        }else{
                            self.airInfo.text = "Not Available"
                        }
                        if self.tvMazeID == nil {
                            self.button.enabled = false
                        }
                    }
                }
                task.resume()
            }
        }
        task.resume()
        //getTVMazeID(tvDBID)
    }
    
    //get the total number of seasons the show has.
    func getShowInfo() {
        
        let url = NSURL(string: "https://api.themoviedb.org/3/tv/\(showID)?api_key=82bf1c5f02fa122f8de61e355a180c6e&language=en-US")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            let showInfo = JSON(data: data!)
           // print(showInfo)
            let allSeasons = showInfo["seasons"].array
           // print(allSeasons)
            for season in allSeasons! {
                if season["season_number"] != 0 && season["poster_path"] != nil { //check if the seasons has come out
                    //print(season)
                    self.seasonNumEpi.append((seasonNumber: season["season_number"].int!, totalNumEpisodes:season["episode_count"].int!))
                }
            }
            
            for genre in showInfo["genres"].array! {
                self.genresArray.append((genreID:genre["id"].int!, genreName: genre["name"].string!))
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.totalSeasons.text = "\(self.seasonNumEpi.count) Seasons"
                self.genreLabel.text = showInfo["genres"][0]["name"].string //update to show all genres
                if showInfo["backdrop_path"] != nil {
                    self.imageLink = showInfo["backdrop_path"].string! //dix this to use different image
                }
                
                //print(showInfo["networks"])
                let net = showInfo["networks"][0]["name"]
                if (net != nil){
                      self.network = showInfo["networks"][0]["name"].string!
                }
              
                self.seasonsTableView.reloadData()
            }
        }
        task.resume()
    }
    
    //to transfer the info from the cell into the episode View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier ==  "episodeSegue"){
            let viewController = segue.destinationViewController as! EpisodeViewController
            //let selectedCell = sender as? SeasonsTableViewCell
            let rowInt = (seasonsTableView.indexPathForSelectedRow?.row)!
            viewController.genreShow = genreLabel.text
            viewController.imageShow = imageShow.image
            viewController.totalEpisodes = seasonNumEpi[rowInt].totalNumEpisodes
            viewController.seasonNumber = seasonNumEpi[rowInt].seasonNumber
            viewController.showID = showID!
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //getVideos
    func getVideo(){
        let url = NSURL(string: "https://api.themoviedb.org/3/tv/\(showID)/videos?api_key=82bf1c5f02fa122f8de61e355a180c6e&language=en-US")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let videoInfo = JSON(data: data!)["results"].array
            //print("printing \(videoInfo)")
            var allVideos:[String] = []
            if videoInfo != nil {
                for a in videoInfo!{
                    //print(a)
                    if a["type"] == "Trailer" {
                        // print(a["key"].string!)
                        allVideos.append(a["key"].string!)
                    }else if a["type"] == "Opening Credits" {
                        allVideos.append(a["key"].string!)
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if(allVideos.count >= 1){
                    let youtubeURL = "https://www.youtube.com/embed/\(allVideos[0])"
                    self.webview.allowsInlineMediaPlayback = true
                    self.webview.loadHTMLString("<iframe width=\"\(self.webview.frame.width)\" height=\"\(self.webview.frame.height)\" src=\"\(youtubeURL)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
                }
            }
        }
        task.resume()
        
    }

    
    // MARK: Adding show to Favorites
    
    @IBAction func addShowToList() {
        button.enabled = false
        
        let showAdder = ShowAdder(vc: self)
        showAdder.updateUser()
    }
}