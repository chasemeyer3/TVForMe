//
//  AddShowToFavorites.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 11/28/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ShowAdder {
    
    // MARK: Variables
    
    var tvShowName: String?
    var genresArray: [(genreID: Int, genreName: String)]?
    var tvShowImage: UIImage?
    var showID: Int!
    var tvDBShowInfo: JSON!
    var showDescription: String?
    var network: String?
    var imageLink: String?
    var rating: String?
    var airInfo: String?
    var tvMazeID:Int!
    var tvdbID:Int!
    var nextEpisodeLink:String?
    
    var user: NSManagedObject?
    
    var favoriteShows = [Int]()
    var mostLikedGenres = [Int]()
    
    var allRecommendationsReturned = [JSON]()
    var filteredRecommendations = [Int]()
    
    var updatedGenrePreferences: [Int: Int]?
    
    // MARK: init
    
    init(vc: TVShowsViewController) {
        self.tvShowName = vc.tvShowName
        self.genresArray = vc.genresArray
        self.tvShowImage = vc.tvShowImage
        self.showID = vc.showID
        self.tvDBShowInfo = vc.tvDBShowInfo
        self.showDescription = vc.showDescription.text
        self.network = vc.network
        self.imageLink = vc.imageLink
        self.rating = vc.ratingLabel.text
        self.airInfo = vc.airInfo.text
        self.tvMazeID = vc.tvMazeID
        self.tvdbID = vc.tvDBID
        self.nextEpisodeLink = vc.nextEpisodeLink
        
        self.user = PullUser()
    }
    
    // MARK: Function to update user: add to faves, redo Recommended...
    
    func updateUser() {
        
        addShowToList()
        updateGenrePreferences()
        print("Moving on to prepareRecommended")
        prepareRecommended()
    }
    
    // MARK: Add show to list functions
    
    private func addShowToList() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        addAsTvShowEntity(managedContext)
        addToUserFavoriteShows(managedContext)
        
    }
    
    private func addAsTvShowEntity(managedContext: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("TvShow", inManagedObjectContext: managedContext)
        let coreDataShow = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let a: String?
        print (tvDBShowInfo["_links"])
        a = tvDBShowInfo["_links"]["nextepisode"]["href"].string
        
        
        if a != nil {
            nextEpisodeLink = tvDBShowInfo["_links"]["nextepisode"]["href"].string
        }


        coreDataShow.setValue(tvShowName, forKey: "name")
        coreDataShow.setValue(genresArray as? AnyObject, forKey: "genres")
        //coreDataShow.setValue(tvShowImage, forKey: "name")
        coreDataShow.setValue(showID, forKey: "movieDBID")
        coreDataShow.setValue(nextEpisodeLink, forKey: "nextEpisode")
        coreDataShow.setValue(showDescription, forKey:  "showDescription")
        coreDataShow.setValue(imageLink, forKey: "imageLink")
        coreDataShow.setValue(network, forKey: "network")
        coreDataShow.setValue(rating, forKey: "rating")
        coreDataShow.setValue(airInfo, forKey: "airingTime")
        
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    private func addToUserFavoriteShows(managedContext: NSManagedObjectContext) {
        var favoriteShows = user!.valueForKey("favoriteShows") as! [Int]
        var tvmaze = user!.valueForKey("tvMazeID") as! [Int]
        var showInCal = user!.valueForKey("showsInCal") as! [Int:Bool]
        
        favoriteShows += [showID]
        tvmaze += [tvMazeID]
        showInCal[tvMazeID] = false
        
        user!.setValue(favoriteShows, forKey: "favoriteShows")
        user!.setValue(showInCal, forKey: "showsInCal")
        user!.setValue(tvmaze, forKey: "tvMazeID")

        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        self.favoriteShows = favoriteShows
    }
    
    // MARK: Function to update genre preferences
    
    private func updateGenrePreferences() {
        var genrePreferences = user!.valueForKey("genrePreferences") as! [Int: Int]
        print("genre preferences = ", genrePreferences)
        
        if genresArray != nil && !genresArray!.isEmpty {
            for i in genresArray! {
                let genre = i.genreID
                print(genre)
                
                // Sometimes MovieDB users put a genre ID that actually is supposed to only apply to movies. So this conditional statement ensures that those movie genre IDs get ignored.
                if genrePreferences[genre] != nil {
                    genrePreferences.updateValue(genrePreferences[genre]! + 1, forKey: genre)
                }
            }
        }
        
        self.updatedGenrePreferences = genrePreferences
        print("updated genre preferences = \(genrePreferences)")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        user!.setValue(genrePreferences, forKey: "genrePreferences")
        
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    // MARK: Functions to recalculate Recommended Shows
    
    private func prepareRecommended() {

        self.mostLikedGenres = getMostLikedGenres(updatedGenrePreferences!)
        
        print("MOST LIKED GENRES = \(mostLikedGenres)")
        
        getRecommendations(mostLikedGenres[0])
        print("Finished with first fetch")
    }
    
    private func getMostLikedGenres(genrePreferences: [Int: Int]) -> [Int] {
        var mostLiked = 0
        var highestQty = 0
        var secondMostLiked = 0
        var secondHighestQty = 0
        
        for (genreID, qtyLiked) in genrePreferences {
            if qtyLiked > highestQty {
                secondMostLiked = mostLiked
                secondHighestQty = highestQty
                
                mostLiked = genreID
                highestQty = qtyLiked
            } else if qtyLiked > secondHighestQty {
                secondMostLiked = genreID
                secondHighestQty = qtyLiked
            }
        }
        
        return [mostLiked, secondMostLiked]
    }
    
    
    private func getRecommendations(genreID: Int) {
        let url = NSURL(string: "https://api.themoviedb.org/3/discover/tv?api_key=82bf1c5f02fa122f8de61e355a180c6e&language=en-US&sort_by=popularity.desc&page=1&timezone=America/Austin&vote_average.gte=7&with_genres=\(mostLikedGenres[0])&include_null_first_air_dates=false")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            self.allRecommendationsReturned = JSON(data: data!)["results"].array!
            print("Executing while loop. Genre is", genreID)
            
            self.processRecommendations()
        }
        task.resume()
    }
    
    private func processRecommendations() {
        for i in 0..<allRecommendationsReturned.count {
            print("EXECUTING ONCE.")
            print(allRecommendationsReturned.count)
            let show = allRecommendationsReturned[i]
            let id = show["id"].int!
            if !favoriteShows.contains(id) {
                filteredRecommendations.append(id)
            }
        }
        
        print("HERE ARE THE FILTERED RECOMMENDATIONS: ", filteredRecommendations)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        user!.setValue(filteredRecommendations as AnyObject, forKey: "recommendedShows")
        
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
}