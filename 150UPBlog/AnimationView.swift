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
    
    let storage = NSUserDefaults.standardUserDefaults()
    
    private var menu: Menu = Menu()
    
    let red = UIColor(red: 212/255, green: 12/255, blue: 28/255, alpha: 1)
    let blue = UIColor(red: 24/255, green: 138/255, blue: 209/255, alpha: 1)
    
    var link:String = String()
    
    var menuIsOpen = false
    
    let date: NSDate = NSDate()
    let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var tomorrow:NSDate!
    var newDate:NSDate!
    var dateTomorrow:NSDate!
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        boxImage.animation = "slideDown"
//        boxImage.autostart = true
//        boxImage.animate()
        
        boxImage.frame = CGRectMake((view.frame.size.width / 2) - 10, (view.frame.size.height / 2) - 10, 20, 20)
        boxImage.layer.cornerRadius = boxImage.frame.size.width / 2
        
        bigImg.frame = CGRectMake((view.frame.size.width / 2) - 10, (view.frame.size.height / 2) - 10, 20, 20)
        bigImg.layer.cornerRadius = boxImage.frame.size.width / 2
        
        ReadButton.hidden = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        tomorrow = cal.dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])!
        newDate = cal.startOfDayForDate(date)
        dateTomorrow = cal.startOfDayForDate(tomorrow)
        
        let components = cal.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        
        dateLabel.text = "\(day).\(month).\(year)"
        

        
        
        let triggerTime = (Int64(NSEC_PER_MSEC) * 250)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.doTheMagic()
        })
        
        
        self.menu.view.frame.origin.x = self.menu.view.frame.origin.x - self.menu.view.frame.size.width
        self.menu.view.frame.size.width = 200
        self.menu.view.backgroundColor = blue
        self.view.addSubview(self.menu.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnimationView.observerNotification), name: "notificationSetted", object: nil)
        
        
//        dateLabel.y = -40
//        dateLabel.duration = 0.5
//        dateLabel.delay = 1
//        dateLabel.animate()
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    func doTheMagic(){
        
        let query = Post.query()!
        
        query.whereKey("PublishDate", greaterThanOrEqualTo:newDate)
        query.whereKey("PublishDate", lessThan:dateTomorrow)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) scores.")
                
                if let objects = objects {
                    
                    let post = (objects as? [Post])?.first
                    
                    print(post?.objectId)
                    self.titleLabel.text = post!.Title
                    self.tagLabel.text = "#" + (post!.tag)
                    self.link = (post?.URL)!
                    
                    let userImageFile = post!.HeroImg
                    
                    self.inAnimation()
                    
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                    
                                let image = UIImage(data:imageData)
                                self.bigImg.image = image
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
    
    
    
    func inAnimation(){
        
        UIView.animateWithDuration(0.3) {
            
            self.boxImage.layer.cornerRadius = 1
            self.boxImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)
            
            self.bigImg.layer.cornerRadius = 1
            self.bigImg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)
            
            }
        
            self.bigImg.opacity = 0
            self.bigImg.duration = 3
            self.bigImg.animate()
            
            self.titleLabel.y = -10
            self.titleLabel.opacity = 0
            self.titleLabel.duration = 0.9
            self.titleLabel.delay = 1
            self.titleLabel.animate()
            
            self.tagLabel.y = -10
            self.tagLabel.opacity = 0
            self.tagLabel.duration = 0.9
            self.tagLabel.delay = 1.5
            self.tagLabel.animate()
            
            self.ReadButton.hidden = false
            self.ReadButton.setTitle("Read", forState: .Normal)
            self.ReadButton.y = -10
            self.ReadButton.duration = 0.9
            self.ReadButton.opacity = 0
            self.ReadButton.delay = 1.5
            self.ReadButton.animate()           
    }
    
    
    @IBAction func buttonGo(sender: SpringButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: link)!)
        
    }
    
    func observerNotification() {
        
        if UIApplication.sharedApplication().currentUserNotificationSettings()?.types.rawValue != 0 {
            
            menu.button.setTitle("ON", forState: .Normal)
            menu.notificatonScheduling()
            storage.setBool(true, forKey: "notification")
            
        } else {
            
            menu.button.setTitle("OFF", forState: .Normal)
            menu.buttonTime.alpha = 0.1
            menu.atText.alpha = 0.1
            storage.setBool(false, forKey: "notification")
        }
        
    }
    
    
    
}
