//
//  AnimationView.swift
//  150UPBlog
//
//  Created by DAdo150 on 5/23/16.
//  Copyright © 2016 150UP. All rights reserved.
//

import UIKit
import Spring
import Parse

class AnimationView: UIViewController {
    @IBOutlet weak var bigImg: SpringImageView!
    @IBOutlet weak var boxImage: SpringView!
    @IBOutlet weak var titleLabel: SpringLabel!
    @IBOutlet weak var tagLabel: SpringLabel!
    @IBOutlet weak var ReadButton: SpringButton!
    @IBOutlet weak var dateLabel: SpringLabel!
    
    private var menu: Menu = Menu()
    
    var menuIsOpen = false
    
    let date: NSDate = NSDate()
    let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var tomorrow:NSDate!
    var newDate:NSDate!
    var dateTomorrow:NSDate!
    
    var positionOriginal:CGRect!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        boxImage.frame = CGRectMake((view.frame.size.width / 2) - 10, (view.frame.size.height / 2) - 10, 20, 20)
        boxImage.layer.cornerRadius = boxImage.frame.size.width / 2
        
        bigImg.frame = CGRectMake((view.frame.size.width / 2) - 10, (view.frame.size.height / 2) - 10, 20, 20)
        bigImg.layer.cornerRadius = boxImage.frame.size.width / 2
        
        ReadButton.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        positionOriginal = boxImage.frame
        
        tomorrow = cal.dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])!
        newDate = cal.startOfDayForDate(date)
        dateTomorrow = cal.startOfDayForDate(tomorrow)
        
        boxImage.animation = "slideDown"
        boxImage.animate()
        
        doTheMagic()
        
        self.menu.view.frame.origin.x = self.menu.view.frame.origin.x - self.menu.view.frame.size.width
        self.menu.view.frame.size.width = 200
        self.menu.view.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.menu.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func button(sender: AnyObject) {
        UIView.animateWithDuration(0.3) {
            self.boxImage.layer.cornerRadius = 1
            self.boxImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)
            
            self.bigImg.layer.cornerRadius = 1
            self.bigImg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)
        }
        
    }
    
    
    
    func doTheMagic(){
        
        let query = PFQuery(className:"Post")
        
        query.whereKey("PublishDate", greaterThanOrEqualTo:newDate)
        query.whereKey("PublishDate", lessThan:dateTomorrow)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        
                        let userImageFile = object["HeroImg"] as! PFFile
                        userImageFile.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    let image = UIImage(data:imageData)
                                    self.bigImg.image = image
                                    
                                    UIView.animateWithDuration(0.3) {
                                        self.boxImage.layer.cornerRadius = 1
                                        self.boxImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)
                                        
                                        self.bigImg.layer.cornerRadius = 1
                                        self.bigImg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)
                                        
                                        self.bigImg.opacity = 0
                                        self.bigImg.duration = 3
                                        self.bigImg.animate()
                                        
                                        self.titleLabel.text = object["Title"] as! String
                                        self.titleLabel.y = -20
                                        self.titleLabel.opacity = 0
                                        self.titleLabel.delay = 1
                                        self.titleLabel.animate()
                                        
                                        self.tagLabel.text = "#" + (object["tag"] as! String)
                                        self.tagLabel.y = -20
                                        self.tagLabel.opacity = 0
                                        self.tagLabel.delay = 1.5
                                        self.tagLabel.animate()
                                        
                                        self.ReadButton.hidden = false
                                        self.ReadButton.setTitle("Read", forState: .Normal)
                                        self.ReadButton.y = -20
                                        self.ReadButton.opacity = 0
                                        self.ReadButton.delay = 1.5
                                        self.ReadButton.animate()
                                        
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    @IBAction func openMenu(sender: UIPanGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Changed) {
            
            if menuIsOpen == false{
                let translation = sender.translationInView(self.view).x
                
                if (translation > self.menu.view.frame.size.width) {
                    self.menu.view.frame.origin.x = 0
                }
                else{
                    self.menu.view.frame.origin.x = translation - self.menu.view.frame.size.width
                }
            }
            
            else {
                
                let translation = sender.translationInView(self.view).x
                
                self.menu.view.frame.origin.x = translation
                
                print(translation)
                
                if (translation > 0) {
                    self.menu.view.frame.origin.x = 0
                }
            }
        }
        
        else if (sender.state == UIGestureRecognizerState.Ended){
            
            if self.menu.view.frame.origin.x > -(self.menu.view.frame.size.width / 2) {
                UIView.animateWithDuration(0.3) {
                    self.menu.view.frame.origin.x = 0
                    self.menuIsOpen = true
                }
            }
            if self.menu.view.frame.origin.x < -(self.menu.view.frame.size.width / 2) {
                UIView.animateWithDuration(0.3) {
                    self.menu.view.frame.origin.x = -self.menu.view.frame.size.width
                    self.menuIsOpen = false

                }
            }
        }
    }
    
    @IBAction func buttonGo(sender: SpringButton) {
    }
    
    
}
