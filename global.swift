//
//  extraFetchFunctions.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 11/26/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var yourShowsForCal = [Int:Bool]()

// this is a function that will update the calendar when new episode times have been added to the api
func getUpcomingShowTimes (){
    let user = PullUser()
    yourShowsForCal = user.valueForKey("showsInCal") as! [Int:Bool]
    for (showID, inCal) in yourShowsForCal {
        print("For the show id: \(showID), user has added to cal: \(inCal)")
        if (inCal == true) {   // this is when the user has requested the show to be added to their calendar -
            let url = NSURL(string: "http://api.tvmaze.com/shows/\(showID)?embed=nextepisode")
            let request = NSURLRequest(URL: url!)
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                let show = JSON(data: data!)["_links"]["nextepisode"]["_embedded"]["nextepisode"]
                print(show["airdate"].string)
            }
            task.resume()
        }
    
    }
    
}


// fetching the core data for the user
func PullUser() -> NSManagedObject {
    print("HERE WE ARE IN PULLUSER()")
    var users = [NSManagedObject]()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let fetchRequest = NSFetchRequest(entityName: "User")
    var fetchedResults: [NSManagedObject]? = nil
    
    do {
        try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
    } catch {
        let nserror = error as NSError
        NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
        abort()
    }
    
    if let results = fetchedResults {
        users = results
    }
    
    print("recommended as pulled in PullUser(): ", users[0].valueForKey("recommendedShows"))
    
    return users[0]
}


func ConvertGenreIDToGenre(genreID: Int) -> String {

    var genre = "N/A"
    
    switch genreID {
        case 28:
            genre = "Action"
        case 12:
            genre = "Adventure"
        case 10759:
            genre = "Action & Adventure"
        case 16:
            genre = "Animation"
        case 35:
            genre = "Comedy"
        case 80:
            genre = "Crime"
        case 99:
            genre = "Documentary"
        case 18:
            genre = "Drama"
        case 10751:
            genre = "Family"
        case 14:
            genre = "Fantasy"
        case 36:
            genre = "History"
        case 27:
            genre = "Horror"
        case 10762:
            genre = "Kids"
        case 10402:
            genre = "Music"
        case 9648:
            genre = "Mystery"
        case 10763:
            genre = "News"
        case 10764:
            genre = "Reality"
        case 10749:
            genre = "Romance"
        case 878:
            genre = "Science Fiction"
        case 10765:
            genre = "Sci-Fi & Fantasy"
        case 10766:
            genre = "Soap"
        case 10767:
            genre = "Talk"
        case 53:
            genre = "Thriller"
        case 10770:
            genre = "TV Movie"
        case 10768:
            genre = "War & Politics"
        case 37:
            genre = "Western"
        default:
            genre = "N/A"
    }
    
    return genre
}

// the code below is being considered for additional future functionality


// function for checking the calender to make sure double events are not added ( currently not implemented)
//func updateCalWithNewShows() {
//    getUpcomingShowTimes()
//    
//    
//    for (showID, inCal) in yourShowsForCal {
//        
//        // set the variables to hold the data for each show
//        var airtime: String?
//        var airdate: String?
//        var runtime: Int?
//        var showName: String?
//        var episodeName: String = ""
//        
//        print("For the show id: \(showID), user has added to cal: \(inCal)")
//        if (inCal == true) {   // this is when the user has requested the show to be added to their calendar -
//            let url = NSURL(string: "http://api.tvmaze.com/shows/\(showID)?embed=nextepisode")
//            let request = NSURLRequest(URL: url!)
//            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
//            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
//                let show = JSON(data: data!)
//                airtime = show["_embedded"]["nextepisode"]["airtime"].string
//                airdate = show["_embedded"]["nextepisode"]["airdate"].string
//                runtime = show["_embedded"]["nextepisode"]["runtime"].int
//                showName = show["name"].string
//                episodeName = show["_embedded"]["nextepisode"]["name"].string!
//                print(show["airdate"].string)
//            }
//            task.resume()
//            
//            if ((showName == nil) || (airdate == nil) || (airtime == nil) || (runtime == nil)){
//                continue
//            }
//            else{
//                // then check the calendar to see if the events have already been added
//                let dateFormatter = NSDateFormatter()
//                let dateString = airdate! + " " + airtime!
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//                let startDate = dateFormatter.dateFromString(dateString)
//                print(startDate)
//                
//                let endDate = (startDate?.dateByAddingTimeInterval(60 * Double(runtime!)))!
//                let predicate2 = eventStore.predicateForEventsWithStartDate(startDate!, endDate: endDate, calendars: calendars)
//                
//                print("startDate:\(startDate) endDate:\(endDate)")
//                let events = eventStore.eventsMatchingPredicate(predicate2) as [EKEvent]!
//                
//                if events != nil {
//                    
//                    print("getting here")
//                    for event in events {
//                        print("Title  \(event.title)" )
//                        print("stareDate: \(event.startDate)" )
//                        print("endDate: \(event.endDate)" )
//                        
//                        if event.title == showName! {
//                            print("Found Previous Entry, not adding the item to the calendar")
//                            // Uncomment if you want to delete
//                            //eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
//                        }
//                        else {
//                            addEpisodeToCal(showName!, episodeName: episodeName, airDate: airdate!, airTime: airtime!, runtime: runtime!)
//                        }
//                    }
//                }
//                else {
//                    addEpisodeToCal(showName!, episodeName: episodeName, airDate: airdate!, airTime: airtime!, runtime: runtime!)
//                }
//                
//            }
//        }
//    }
//}

// function to add an individual episode to the calendar   (currently not implemented)
//func addEpisodeToCal(showName: String, episodeName: String, airDate: String, airTime: String, runtime: Int) {
//    print("Adding", showName, "to the calendar")
//    print("airtime", airTime)
//    print("airdate", airDate)
//    // might be good to change this so that it wont cause a problem if the date and time are not provided
//    // initillize the date formatter and change the date format to the desired format
//    let dateFormatter = NSDateFormatter()
//    let dateString = airDate + " " + airTime
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//    let startDate = dateFormatter.dateFromString(dateString)
//    print(" This is in the shows more cell", startDate)
//    
//    eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
//        granted, error in
//        if (granted) && (error == nil) {
//            print("granted \(granted)")
//            print("error  \(error)")
//            let event:EKEvent = EKEvent(eventStore: eventStore)
//            event.title = showName
//            event.startDate = startDate!
//            event.endDate = (startDate?.dateByAddingTimeInterval(60 * Double(runtime)))!   // this could cause problems
//            print("end date:", event.endDate)
//            event.notes = episodeName
//            event.calendar = eventStore.calendarWithIdentifier(calendars[tvShowCalIndex].calendarIdentifier)!
//            //eventStore.saveEvent(event, span: .ThisEvent, commit: (
//            do {
//                try eventStore.saveEvent(event, span: .ThisEvent)
//            } catch let specificError as NSError {
//                print("A specific error occurred: \(specificError)")
//            } catch {
//                print("An error occurred")
//            }
//            print("Saved Event")
//        }
//    })
//    
//}


