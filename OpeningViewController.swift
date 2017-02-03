//
//  OpeningViewController.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 12/2/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit
import EventKit

class OpeningViewController: UIViewController {

    //let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCalAuthorization()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    func checkCalAuthorization(){
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:    // this is for when the user first opens the app
            requestCalAccess()
        case EKAuthorizationStatus.Authorized:       // when this is true allow the user to add the item to their
            print("User has previously opened the app and authorized Calendar access")
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            //make an alert for the user  to give access to the cal before this feature can be used
            print("denied access to calendar")
        }
        
    }
    
    func requestCalAccess () {
        eventStore.requestAccessToEntityType(EKEntityType.Event,  completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(), {
                    
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    //make an alert telling the user to give access
                    print("denied access to calendar")
                })
            }
        })
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
