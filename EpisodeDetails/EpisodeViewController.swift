//
//  EpisodeViewController.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 11/14/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var episodeSummary: UILabel!
    @IBOutlet weak var episodeDirector: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var episodeAirInfo: UILabel!
    @IBOutlet weak var episodeRating: UILabel! //get from TVDB?
    @IBOutlet weak var episodeTableView: EpisodeTableViewCell!
    
    
    
    var seasonNumber:Int!
    var imageShow:UIImage!
    var genreShow:String!
    var totalEpisodes:Int!
    var episodeSelected = 1
    var showID:Int!
    var fromAiringSoon = false
    var episodeDescription = ""
    var airingInfo = ""
    var runningTimeInfo = ""
    var nameOfEpisode = ""
    var rating = "No Rating Available"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // image.image = imageShow
        //genre.text = genreShow //both this inside after the info comes in
        if !fromAiringSoon {
            loadShowInfo(episodeSelected)
        }else{
            image.image = imageShow
            episodeAirInfo.text = airingInfo
            episodeSummary.text = episodeDescription
            episodeName.text = nameOfEpisode
            episodeRating.text = rating
            genre.text = genreShow
            episodeDirector.text = runningTimeInfo
        }
        
    }
    
    
    func loadShowInfo(episode: Int){
        
        let url = NSURL(string: "https://api.themoviedb.org/3/tv/\(showID)/season/\(seasonNumber)/episode/\(episode)?api_key=82bf1c5f02fa122f8de61e355a180c6e&language=en-US") //how to make it so it reloads with the one selected
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let episodeInfo = JSON(data: data!)
            //print(episodeInfo)
            dispatch_async(dispatch_get_main_queue()) {
                //self.totalSeasons.text = "\(self.seasonsWithId.count) Seasons"
                // self.seasonsTableView.reloadData()
                self.image.image = self.imageShow
                self.genre.text = self.genreShow
                self.episodeName.text = episodeInfo["name"].string
                self.episodeSummary.text = episodeInfo["overview"].string
                let time = episodeInfo["runtime"]
                if time == nil {
                    self.episodeDirector.text = "Unknown minutes" //fix this
                }else{
                     self.episodeDirector.text = "\(episodeInfo["runtime"]) minutes." //fix this
                }
               
                self.episodeAirInfo.text = "Premiered: \(episodeInfo["air_date"])"
                self.episodeRating.text = "\(episodeInfo["vote_average"].int!) stars"
            }
        }
        task.resume()
        
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return totalEpisodes
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EpisodeTableViewCell", forIndexPath: indexPath) as! EpisodeTableViewCell
        
        cell.episode.text = "Episode \(indexPath.row + 1)" //episode by name? can i get all the episodes per season?
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        loadShowInfo(indexPath.row + 1 )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
