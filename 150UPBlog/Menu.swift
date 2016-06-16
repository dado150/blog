//
//  Menu.swift
//  150UPBlog
//
//  Created by DAdo150 on 5/23/16.
//  Copyright © 2016 150UP. All rights reserved.
//

import UIKit
import Spring
import Parse

class Menu: UIViewController {
    
    @IBOutlet weak var notificationLabe: UILabel!
    
    var buttonTime = UIButton()
    var atText = UILabel()
    var button = UIButton()
    var introText = UILabel()
    var credits = UILabel()
    var goToSettings:Bool = false
    
    let storage = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        introText = UILabel(frame: CGRect(x: 0, y: 40, width: 200.00, height: 60.00));
        introText.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        introText.numberOfLines = 0
        introText.text = "Turn my daily \n notifications"
        introText.setLineHeight(4)
        introText.textAlignment = NSTextAlignment.Center
        introText.textColor = UIColor.whiteColor()
        introText.font = UIFont (name: "Brown-Regular", size: 17)
        self.view.addSubview(introText)
        
        
        button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 100, 200, 50)
        button.titleLabel?.font = UIFont (name: "Brown-Bold", size: 34)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        atText = UILabel(frame: CGRect(x: 0, y: 160, width: 200.00, height: 40.00));
        atText.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        atText.numberOfLines = 0
        atText.text = "at"
        atText.textAlignment = NSTextAlignment.Center
        atText.textColor = UIColor.whiteColor()
        atText.font = UIFont (name: "Brown-Regular", size: 20)
        self.view.addSubview(atText)
        
        buttonTime = UIButton(type: UIButtonType.System) as UIButton
        buttonTime.frame = CGRectMake(0, 190, 200, 50)
        buttonTime.titleLabel?.font = UIFont (name: "Brown-Bold", size: 34)
        buttonTime.setTitle("\(storage.valueForKey("timeNotification")!):00", forState: .Normal)
        buttonTime.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buttonTime.addTarget(self, action: #selector(setTimeNotification), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonTime)
        
        credits = UILabel(frame: CGRect(x: 0, y: view.frame.size.height - 100, width: 200.00, height: 80.00));
        credits.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        credits.numberOfLines = 0
        credits.text = "Things we found \n out yesterday"
        credits.setLineHeight(4)
        credits.textAlignment = NSTextAlignment.Center
        credits.textColor = UIColor.whiteColor()
        credits.font = UIFont (name: "Brown-Regular", size: 15)
        self.view.addSubview(credits)
        
        let imageName = "150up.png"
        let image = UIImage(named: imageName)
        let logo = UIImageView(image: image!)
        logo.frame = CGRect(x: (200 - 73) / 2, y: view.frame.size.height - 141 , width: 73, height: 44)
        view.addSubview(logo)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(AppBackFromBackground), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
    }
    
    
     
    func buttonAction(sender:UIButton!){
        
        if (storage.boolForKey("notification")) == true {
            
           notificationOff()
            sender.setTitle("OFF", forState: .Normal)
        }
            
        else {
            
            if UIApplication.sharedApplication().currentUserNotificationSettings()?.types.rawValue == 0 {
                
                storage.setBool(false, forKey: "notification")
                
                let refreshAlert = UIAlertController(title: "Notifications", message: "You don't have notifications enabled", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Go to settings", style: .Default, handler: { (action: UIAlertAction!) in
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                        self.goToSettings = true                   
                        
                    }
                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                
                presentViewController(refreshAlert, animated: true, completion: nil)
                
            } else {
                
                notificationOn()
                sender.setTitle("ON", forState: .Normal)}
            
            }
    }
    
    
    func setTimeNotification(){
        
        NSUserDefaults.incrementIntegerForKey("timeNotification")
        
            if storage.integerForKey("timeNotification") >= 24{
                storage.setInteger(0, forKey: "timeNotification")
            }
        
            buttonTime.setTitle("\(storage.valueForKey("timeNotification")!):00", forState: .Normal)

        
        notificationOn()
    }
    
    
    func notificationOn(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        button.setTitle("ON", forState: .Normal)
        notificatonScheduling()
        buttonTime.userInteractionEnabled = true
        buttonTime.alpha = 1
        atText.alpha = 1
        storage.setBool(true, forKey: "notification")
    }
    
    func notificationOff(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        button.setTitle("OFF", forState: .Normal)
        buttonTime.alpha = 0.1
        atText.alpha = 0.1
        storage.setBool(false, forKey: "notification")
    }
    
    func notificatonScheduling() {
        
        let date2: NSDate = NSDate()
        let cal2: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let date19: NSDate = cal2.dateBySettingHour(storage.integerForKey("timeNotification"), minute: 0, second: 0, ofDate: date2, options: NSCalendarOptions())!
        let notification = UILocalNotification()
        notification.fireDate = date19
        notification.alertBody = "Your daily feed is up"
        notification.alertAction = "Get it"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.repeatInterval = NSCalendarUnit.Day
        notification.userInfo = ["dailyNotification": "150UP"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func appMovedToBackground() {
    }
    
    func AppBackFromBackground(){
        
        if goToSettings == true {
            
            if UIApplication.sharedApplication().currentUserNotificationSettings()?.types.rawValue != 0 {
                notificationOn()
                goToSettings = false
            }
        } else {
            goToSettings = false
        }
    }
    
}

extension NSUserDefaults {
    class func incrementIntegerForKey(key:String) {
        let defaults = standardUserDefaults()
        let int = defaults.integerForKey(key)
        defaults.setInteger(int+1, forKey:key)
    }
}


