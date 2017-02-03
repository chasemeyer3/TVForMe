//
//  OnTonightTableViewController.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 11/27/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit

class OnTonightTableViewController: UITableViewController {
    
    var showsOnTonight: JSON?
    var showsNotYetAired = [JSON]()
    var showsNotYetAiredCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getShowsOnTonight()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getShowsOnTonight() {
        let url = NSURL(string: "http://api.tvmaze.com/schedule")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            self.showsOnTonight = JSON(data: data!)
            print(self.showsOnTonight![0])
            self.eliminatePastAirtimes()
            self.showsNotYetAiredCount = self.showsNotYetAired.count
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func eliminatePastAirtimes() {
        let dateToday = NSDate()
        let todayDateFormatter = NSDateFormatter()
        todayDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        todayDateFormatter.timeZone = NSTimeZone(abbreviation: "CST");
        let cstDateToday = todayDateFormatter.stringFromDate(dateToday);
        
        //let airtimeDateFormatter = NSDateFormatter()
        //airtimeDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for episode in showsOnTonight!.array! {
            //let airtime = airtimeDateFormatter.dateFromString(episode["airdate"].string! + " " + episode["airtime"].string!)
            let airtime = episode["airdate"].string! + " " + episode["airtime"].string!
            
            // If current time is after time listed for show
            if cstDateToday.compare(airtime) == NSComparisonResult.OrderedDescending {
                continue
                
                // If current time is before time listed for show
            } else {
                self.showsNotYetAired.append(episode)
                //self.showsOnTonight!.splice(episodeCounter, 0)
                //var subsequence = self.showsOnTonight!.dropFirst(episodeCounter)
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsNotYetAiredCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShowAirtime") as! ShowAirtimeCell
        
        let episode = self.showsNotYetAired[indexPath.row]
        
        //cell.airtimeLabel.text = episode["airtime"].string
        cell.networkLabel.text = episode["show"].dictionary!["network"]!.dictionary!["name"]!.string
        cell.showNameButton.setTitle(episode["show"].dictionary!["name"]!.string, forState: .Normal)
        cell.episodeNameButton.setTitle(episode["name"].string, forState: .Normal)
        
        let timeAsString = episode["airtime"].string!
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let airtime = timeFormatter.dateFromString(timeAsString)
        timeFormatter.dateFormat = "h:mm a"
        let reformattedAirtime = timeFormatter.stringFromDate(airtime!)
        
        cell.airtimeLabel.text = reformattedAirtime
        //cell.airtimeLabel.text = episode["airtime"].string
        cell.networkLabel.text = episode["show"].dictionary!["network"]!.dictionary!["name"]!.string
        cell.showNameButton.setTitle(episode["show"].dictionary!["name"]!.string, forState: .Normal)
        cell.episodeNameButton.setTitle(episode["name"].string, forState: .Normal)
        cell.showName = episode["show"].dictionary!["name"]!.string
        cell.tvMazeID = episode["show"]["id"].int
        //cell.genre = episode["show"]
        cell.premiered = episode["show"]["premiered"].string
        cell.runtime = episode["show"]["runtime"].int
        cell.days = episode["show"]["schedule"]["days"][0].string //make into array
        cell.rating = episode["show"]["rating"].int
        cell.showDescription = episode["show"]["summary"].string
        cell.time = episode["show"]["schedule"]["time"].string
        
        return cell
    }
    
    //segue to shows from on tonight
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //ToShow
        if (segue.identifier ==  "tonightToShow"){
            let viewController = segue.destinationViewController as! TVShowsViewController
            //get cell
            let cell = sender as? ShowAirtimeCell
            //            let view = selectedButton.superview!
            //            let cell =  view.superview as! ShowAirtimeCell
            
            
            //            viewController.showID = returnedShows![tableView.indexPathForSelectedRow!.row]["id"].int // need from moviedb
            //            viewController.tvShowImage = selectedCell!.showImage.image //maybe from moviedb?
            viewController.released = cell!.premiered
            //            viewController.tvShowRating = selectedCell!.rating.text
            //            viewController.tvShowDescription = selectedCell!.showDesc.text
            viewController.tvShowName = cell!.showName
            viewController.tvMazeID = cell!.tvMazeID
            viewController.day =  cell!.days
            viewController.time = cell!.time
            viewController.fromOnTonight = true
            viewController.tvShowRating = "\(cell!.rating)"
            viewController.tvShowDescription = cell!.showDescription
            viewController.nextEpisodeLink = showsNotYetAired[tableView.indexPathForSelectedRow!.row]["show"]["_links"]["nextepisode"]["href"].string
            //            viewController.imageLink = returnedShows![tableView.indexPathForSelectedRow!.row]["poster_path"].string!
            
            //
            //            let urlString = showsNotYetAired[tableView.indexPathForSelectedRow!.row]["show"]["image"]["medium"]
            //
            //            if  urlString != nil {
            //                let url = NSURL(string: urlString.string!)
            //                if let data = NSData(contentsOfURL: url!) {
            //                    dispatch_async(dispatch_get_main_queue()) {
            //                        //self.imageURL =  urlString.string!
            //                         print(urlString.string)
            //                        viewController.tvShowImage = UIImage(data: data)
            //                    }
            //                }
            //            }
            
            
            
            //ToEpisode
        }
    }
}
/*
{"id":992041,
    "url":"http://www.tvmaze.com/episodes/992041/bloomberg-best-2x146-episode-146",
    "name":"Episode 146",
    "season":2,
    "number":146,
    "airdate":"2016-11-27",
    "airtime":"06:00",
    "airstamp":"2016-11-27T06:00:00-05:00",
    "runtime":60,
    "image":null,
    "summary":"",
    "show":{
        "id":9120,
        "url":"http://www.tvmaze.com/shows/9120/bloomberg-best",
        "name":"Bloomberg Best",
        "type":"News",
        "language":"English",
        "genres":[],
        "status":"Running",
        "runtime":60,
        "premiered":"2015-06-13",
        "schedule":{
            "time":"08:00",
            "days":["Saturday","Sunday"]},
        "rating":{"average":null},
        "weight":0,
        "network":{"id":172,
            "name":"Bloomberg TV",
            "country":{"name":"United States",
                "code":"US",
                "timezone":"America/New_York"}},
        "webChannel":null,
        "externals":{"tvrage":null,
            "thetvdb":null,
            "imdb":null},
        "image":{"medium":"http://tvmazecdn.com/uploads/images/medium_portrait/48/120827.jpg",
            "original":"http://tvmazecdn.com/uploads/images/original_untouched/48/120827.jpg"},
        "summary":"<p><strong>Bloomberg Best</strong> hosts June Grasso and Willem Marx feature the best stories of the day from Bloomberg Radio, Bloomberg Television, and over 150 Bloomberg News bureaus around the world on Bloomberg.</p>",
        "updated":1479795292,
        "_links":{
            "self":{"href":"http://api.tvmaze.com/shows/9120"},
            "previousepisode":{"href":"http://api.tvmaze.com/episodes/992042"},
            "nextepisode":{"href":"http://api.tvmaze.com/episodes/995119"}
        }
    },
    "_links":{
        "self":{
            "href":"http://api.tvmaze.com/episodes/992041"
        }
    }
}*/