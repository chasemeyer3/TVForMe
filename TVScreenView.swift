//
//  TVScreenView.swift
//  EpisodeDetails
//
//  Created by Meyer, Chase R on 12/2/16.
//  Copyright © 2016 Meyer, Chase R. All rights reserved.
//

import UIKit
let π:CGFloat = CGFloat(M_PI)

class TVScreenView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let screenPics = [UIImage(named: "theSimpsons")!, UIImage(named: "narcos")!, UIImage(named: "strangerThings")!, UIImage(named: "mrRobot")!, UIImage(named: "gameOfThrones")!, UIImage(named: "familyGuy")!, UIImage(named: "parksAndRec")!, UIImage(named: "walkingDead")!, UIImage(named: "southPark")!, UIImage(named: "rickAndMorty")!, UIImage(named: "westworld")!]

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        drawTV()
        drawUTLabel()
        drawTVLabel()
        imageView.frame = CGRect(x: bounds.width * (15/335), y: bounds.height * (200/625), width: bounds.width * (305/335), height: bounds.height * (185/625))
        var count = 0
        var secondsSim = 0.0
        while count != 1000 {
            count += 1
            let delay = secondsSim * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            secondsSim = secondsSim + 11.0
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                // change the image with a delay
                self.simulateTV()
                
            })
            
        }
    }
    
    func simulateTV() {
        var seconds = 1.0
        // iterate through the list of pictures, showing the images on the screen with with reduced time intervals for each proceeding image
        for img in screenPics{
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            seconds = seconds + 1.0
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                // change the image with a delay
                self.imageView.image = img
                
            })
            
        }
    }
    
    func drawTVLabel(){
        //draw the "T"
        let tOutline = UIBezierPath()
        tOutline.moveToPoint(CGPoint(x: bounds.width * (36.25/335) , y: bounds.height * (430/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (36.25/335), y: bounds.height * (460/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (86.25/335), y: bounds.height * (460/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (86.25/335), y: bounds.height * (570/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (116.25/335), y: bounds.height * (570/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (116.25/335), y: bounds.height * (460/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (166.25/335), y: bounds.height * (460/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (166.25/335), y: bounds.height * (430/625)))
        tOutline.closePath()
        UIColor.blueColor().setFill()
        tOutline.fill()
        
        // draw the "V"
        let vOutline = UIBezierPath()
        vOutline.moveToPoint(CGPoint(x: bounds.width * (170/335) , y: bounds.height * (430/625)))
        vOutline.addLineToPoint(CGPoint(x: bounds.width * (220/335), y: bounds.height * (570/625)))
        vOutline.addLineToPoint(CGPoint(x: bounds.width * (250/335), y: bounds.height * (570/625)))
        vOutline.addLineToPoint(CGPoint(x: bounds.width * (300/335), y: bounds.height * (430/625)))
        vOutline.addLineToPoint(CGPoint(x: bounds.width * (270/335), y: bounds.height * (430/625)))
        vOutline.addLineToPoint(CGPoint(x: bounds.width * (235/335), y: bounds.height * (540/625)))
        vOutline.addLineToPoint(CGPoint(x: bounds.width * (200/335), y: bounds.height * (430/625)))
        vOutline.closePath()
        UIColor.blueColor().setFill()
        vOutline.fill()
    }
    
    
    func drawUTLabel() {
 
        // drawing the left side of the "U" excluding the arc
        let leftSquare = UIBezierPath()
        leftSquare.moveToPoint(CGPoint(x: bounds.width * (70/335) , y: bounds.height * (125/625)))
        leftSquare.addLineToPoint(CGPoint(x: bounds.width * (40/335), y: bounds.height * (125/625)))
        leftSquare.addLineToPoint(CGPoint(x: bounds.width * (40/335), y: bounds.height * (40/625)))
        leftSquare.addLineToPoint(CGPoint(x: bounds.width * (70/335) , y: bounds.height * (40/625)))
        leftSquare.closePath()
        UIColor.orangeColor().setFill()
        leftSquare.fill()
        
        // drawing the right side of the "U" excluding the arc
        let rightSquare = UIBezierPath()
        rightSquare.moveToPoint(CGPoint(x: bounds.width * (130/335) , y: bounds.height * (125/625)))
        rightSquare.addLineToPoint(CGPoint(x: bounds.width * (160/335), y: bounds.height * (125/625)))
        rightSquare.addLineToPoint(CGPoint(x: bounds.width * (160/335), y: bounds.height * (40/625)))
        rightSquare.addLineToPoint(CGPoint(x: bounds.width * (130/335) , y: bounds.height * (40/625)))
        rightSquare.closePath()
        UIColor.orangeColor().setFill()
        rightSquare.fill()
        
        // draw the bottom of the "U"
        let uArc = UIBezierPath()
        uArc.moveToPoint(CGPoint(x: bounds.width * (40/335) , y: bounds.height * (125/625)))
        uArc.addLineToPoint(CGPoint(x: bounds.width * (70/335), y: bounds.height * (125/625)))
        uArc.addLineToPoint(CGPoint(x: bounds.width * (85/335), y: bounds.height * (150/625)))
        uArc.addLineToPoint(CGPoint(x: bounds.width * (115/335) , y: bounds.height * (150/625)))
        uArc.addLineToPoint(CGPoint(x: bounds.width * (130/335), y: bounds.height * (125/625)))
        uArc.addLineToPoint(CGPoint(x: bounds.width * (160/335) , y: bounds.height * (125/625)))
        uArc.addLineToPoint(CGPoint(x: bounds.width * (130/335), y: bounds.height * (180/625)))
        uArc.addLineToPoint(CGPoint(x: bounds.width * (70/335) , y: bounds.height * (180/625)))
        uArc.closePath()
        UIColor.orangeColor().setFill()
        uArc.fill()

        
        //draw the "T"
        let tOutline = UIBezierPath()
        tOutline.moveToPoint(CGPoint(x: bounds.width * (166.25/335) , y: bounds.height * (40/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (166.25/335), y: bounds.height * (70/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (216.25/335), y: bounds.height * (70/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (216.25/335), y: bounds.height * (180/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (246.25/335), y: bounds.height * (180/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (246.25/335), y: bounds.height * (70/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (296.25/335), y: bounds.height * (70/625)))
        tOutline.addLineToPoint(CGPoint(x: bounds.width * (296.25/335), y: bounds.height * (40/625)))
        tOutline.closePath()
        UIColor.orangeColor().setFill()
        tOutline.fill()
    }
    func drawTV (){
        // draw the frame of the tv (black color)
        let frame = UIBezierPath()
        frame.moveToPoint(CGPoint(x: 0, y: bounds.height * (185/625)))
        frame.addLineToPoint(CGPoint(x: 0, y: bounds.height * (400/625)))
        frame.addLineToPoint(CGPoint(x: bounds.width, y: bounds.height * (400/625)))
        frame.addLineToPoint(CGPoint(x: bounds.width, y: bounds.height * (185/625)))
        frame.closePath()
        UIColor.blackColor().setFill()
        frame.fill()
        // draw the screen without an image (gray)
        let screen = UIBezierPath()
        screen.moveToPoint(CGPoint(x: bounds.width * (15/335), y: bounds.height * (200/625)))
        screen.addLineToPoint(CGPoint(x: bounds.width * (15/335), y: bounds.height * (385/625)))
        screen.addLineToPoint(CGPoint(x: bounds.width * (320/335), y: bounds.height * (385/625)))
        screen.addLineToPoint(CGPoint(x: bounds.width * (320/335), y: bounds.height * (200/625)))
        screen.closePath()
        UIColor.grayColor().setFill()
        screen.fill()
        // draw the base for the tv
        let base = UIBezierPath()
        base.moveToPoint(CGPoint(x: bounds.width / 2 , y: bounds.height * (400/625)))
        base.addLineToPoint(CGPoint(x: (bounds.width / 2) - 15, y: bounds.height * (400/625)))
        base.addLineToPoint(CGPoint(x: (bounds.width / 2) - 15, y: bounds.height * (410/625)))
        base.addLineToPoint(CGPoint(x: (bounds.width / 2) - 80, y: bounds.height * (410/625)))
        base.addLineToPoint(CGPoint(x: (bounds.width / 2) - 80, y: bounds.height * (420/625)))
        base.addLineToPoint(CGPoint(x: (bounds.width / 2) + 80, y: bounds.height * (420/625)))
        base.addLineToPoint(CGPoint(x: (bounds.width / 2) + 80, y: bounds.height * (410/625)))
        base.addLineToPoint(CGPoint(x: (bounds.width / 2) + 15, y: bounds.height * (410/625)))
        base.addLineToPoint(CGPoint(x: (bounds.width / 2) + 15, y: bounds.height * (400/625)))
        base.closePath()
        UIColor.blackColor().setFill()
        base.fill()

    }


}
