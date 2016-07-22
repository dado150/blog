//
//  mainView.swift
//  150UPBlog
//
//  Created by DAdo150 on 6/6/16.
//  Copyright © 2016 150UP. All rights reserved.
//

import UIKit
import Parse
import Spring
import Social

class mainView: UIViewController {
    
    let red = UIColor(red: 212/255, green: 12/255, blue: 28/255, alpha: 1)
    let blue = UIColor(red: 24/255, green: 138/255, blue: 209/255, alpha: 1)
    
    var image = UIImage()
    var loadedImage = UIImage()
    var bgView = SpringView()
    var heroImg = SpringImageView()
    var dateLabel = UILabel()
    var button = SpringButton()
    var link:String = String()
    var visit:Int = Int()
    var count = 1
    
    var timer = NSTimer()
    var centerX = CGFloat()
    var centerY = CGFloat()
    

    @IBOutlet weak var titleLabel: SpringLabel!
    @IBOutlet weak var tagLabel: SpringLabel!
    
    private var menu: Menu = Menu()
    var menuIsOpen = false
    
    let date: NSDate = NSDate()
    let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var tomorrow:NSDate!
    var newDate:NSDate!
    var dateTomorrow:NSDate!
    
    let storage = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var marginTopTitle: NSLayoutConstraint!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marginTopTitle.constant = self.view.frame.size.height - 150 + 45
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        
        if launchedBefore  {
            print("Not first launch.")
        }
        else {
            print("First launch, setting NSUserDefault.")
            storage.setBool(true, forKey: "launchedBefore")
            storage.setInteger(19, forKey: "timeNotification")
        }
        
        
        tomorrow = cal.dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])!
        newDate = cal.startOfDayForDate(date)
        dateTomorrow = cal.startOfDayForDate(tomorrow)
        
        let components = cal.components([.Day , .Month , .Year], fromDate: date)
        let yearLong =  components.year
        let month = components.month
        let day = components.day
        let year = yearLong%100
        
        let imageName = "bg.png"
        image = UIImage(named: imageName)!
        heroImg = SpringImageView(image: image)
        
        bgView.frame = CGRectMake((view.frame.size.width / 2) - 10, (view.frame.size.height / 2) - 10, 20, 20)
        bgView.layer.cornerRadius = bgView.frame.size.width / 2
        bgView.backgroundColor = red
        self.view.addSubview(bgView)
        
        bgView.animation = "slideDown"
        bgView.autostart = true
        bgView.duration = 1
        bgView.delay = 1
        bgView.animate()
        
        heroImg.frame = CGRect(x: (view.frame.size.width / 2) - 10, y: (view.frame.size.height / 2) - 10, width: 20, height: 20)
        heroImg.layer.cornerRadius = heroImg.frame.size.width / 2
        heroImg.clipsToBounds = true
        heroImg.contentMode = UIViewContentMode.ScaleAspectFill;
        heroImg.backgroundColor = red
        self.heroImg.alpha = 0
        view.addSubview(heroImg)
        
        dateLabel.frame =  CGRectMake((self.view.frame.size.width / 2) - 42.5, 0, 95, 26)
        dateLabel.textAlignment = NSTextAlignment.Center
        dateLabel.backgroundColor = red
        dateLabel.font = UIFont(name: "Brown-Bold", size: 15)
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.text = "\(day).\(month).\(year)"
        let attributedString = dateLabel.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, attributedString.length))
        dateLabel.attributedText = attributedString
        self.view.addSubview(dateLabel)
        
        titleLabel.textColor = red
        titleLabel.hidden = true
        tagLabel.textColor = blue
        tagLabel.hidden = true
        
        button.frame = CGRect(x: self.view.frame.width / 2 - 69 , y: (self.view.frame.height - 150) / 2, width: 138, height: 52)
        button.backgroundColor = red
        button.titleLabel?.textColor = UIColor.whiteColor()
        button.titleLabel!.font = UIFont(name: "Brown-Bold", size: 30)
        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        button.addTarget(self, action: #selector(selectedButton), forControlEvents: .TouchDown)
        button.hidden = true
        self.view.addSubview(button)
        
        self.menu.view.frame.origin.x = self.menu.view.frame.origin.x - self.menu.view.frame.size.width 
        self.menu.view.frame.size.width = 200
        self.menu.view.backgroundColor = blue
        self.view.addSubview(self.menu.view)
        
        
        if storage.boolForKey("notification") == true{
            menu.button.setTitle("ON", forState: .Normal)
        } else {
           menu.button.setTitle("OFF", forState: .Normal)
        }

        doTheMagic()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(observerNotification), name: "notificationSetted", object: nil)
        
    }
    
    func buttonAction(sender: UIButton!) {

        UIApplication.sharedApplication().openURL(NSURL(string: link)!)
        sender.backgroundColor = red
       
    }
    
    func selectedButton(sender:UIButton!)  {
        sender.backgroundColor = blue
    }

    
    
    
    @IBAction func openMenu(sender: UIPanGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Changed) {
            
            if menuIsOpen == false {
                
                let translation = sender.translationInView(self.view).x
                
                print(translation)
                if (translation > self.menu.view.frame.size.width) {
                    self.menu.view.frame.origin.x = 0
                }
                else{
                    self.menu.view.frame.origin.x = translation - self.menu.view.frame.size.width
                }
            }
            else {
                
                let translation = sender.translationInView(self.view).x
                print(translation)
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
                    self.button.setTitle(post?.Action, forState: .Normal)
                    self.visit = (post?.Visit)!
                    
                    
                    let userImageFile = post!.HeroImg
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                
                                self.loadedImage = UIImage(data:imageData)!
                                self.heroImg.image = self.loadedImage
                                
                            }
                        }
                    }
                    
                   
                    UIView.animateWithDuration(0.3, delay: 2.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                        self.heroImg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)
                        self.bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)
                        self.heroImg.alpha = 1
                        
                    }) { (true) in
                        
                        self.heroImg.layer.cornerRadius = 1
                        self.bgView.layer.cornerRadius = 1
                        self.inAnimation()
                        
                    }
                    
                    post!.Visit = self.visit + 1
                    post!.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                                                        
                        } else {
                            
                        }
                    }
                    
                }
                
            } else {
                self.titleLabel.hidden = false
                self.titleLabel.text = "There is no Internet connection"
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func inAnimation(){
        
        self.titleLabel.hidden = false
        self.titleLabel.y = -10
        self.titleLabel.opacity = 0
        self.titleLabel.duration = 0.9
        self.titleLabel.delay = 0.5
        self.titleLabel.animate()
        
        self.tagLabel.hidden = false
        self.tagLabel.y = -10
        self.tagLabel.opacity = 0
        self.tagLabel.duration = 0.9
        self.tagLabel.delay = 1
        self.tagLabel.animate()
        
        self.button.hidden = false
        self.button.y = -10
        self.button.duration = 0.9
        self.button.opacity = 0
        self.button.delay = 1
        self.button.animate()
    }
    
    func observerNotification() {
        
        if UIApplication.sharedApplication().currentUserNotificationSettings()?.types.rawValue != 0 {
           
            menu.notificationOn()
            menu.button.setTitle("ON", forState: .Normal)
            
        } else {
            
            menu.notificationOff()
            menu.button.setTitle("OFF", forState: .Normal)
        }
        
    }
    
    
}
