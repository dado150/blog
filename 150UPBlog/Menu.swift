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
    
    var goToSettings = Bool()
    
    let storage = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        }
        else {
            print("First launch, setting NSUserDefault.")
            storage.setBool(true, forKey: "launchedBefore")
            storage.setInteger(19, forKey: "timeNotification")
        }
        
        
        introText = UILabel(frame: CGRect(x: 0, y: 60, width: 200.00, height: 60.00));
        introText.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        introText.numberOfLines = 0
        introText.text = "Turn my \n notification"
        introText.setLineHeight(4)
        introText.textAlignment = NSTextAlignment.Center
        introText.textColor = UIColor.whiteColor()
        introText.font = UIFont (name: "Brown-Regular", size: 20)
        self.view.addSubview(introText)
        
        
        button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 120, 200, 50)
        button.titleLabel?.font = UIFont (name: "Brown-Bold", size: 34)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        atText = UILabel(frame: CGRect(x: 0, y: 180, width: 200.00, height: 40.00));
        atText.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        atText.numberOfLines = 0
        atText.text = "at"
        atText.textAlignment = NSTextAlignment.Center
        atText.textColor = UIColor.whiteColor()
        atText.font = UIFont (name: "Brown-Regular", size: 20)
        self.view.addSubview(atText)
        
        buttonTime = UIButton(type: UIButtonType.System) as UIButton
        buttonTime.frame = CGRectMake(0, 210, 200, 50)
        buttonTime.titleLabel?.font = UIFont (name: "Brown-Bold", size: 34)
        buttonTime.setTitle("\(storage.valueForKey("timeNotification")!):00", forState: .Normal)
        buttonTime.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buttonTime.addTarget(self, action: #selector(setTimeNotification), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonTime)
        
        credits = UILabel(frame: CGRect(x: 0, y: view.frame.size.height - 100, width: 200.00, height: 80.00));
        credits.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        credits.numberOfLines = 0
        credits.text = "Things we \n learn everyday"
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
        
    }
    
    
    func buttonAction(sender:UIButton!){
        
        if (storage.boolForKey("notification")) == true {
            sender.setTitle("OFF", forState: .Normal)
            buttonTime.userInteractionEnabled = false
            buttonTime.alpha = 0.1
            atText.alpha = 0.1
            storage.setBool(false, forKey: "notification")
            
            UIApplication.sharedApplication().cancelAllLocalNotifications()            
        }
            
        else {
            
            if UIApplication.sharedApplication().currentUserNotificationSettings()?.types.rawValue == 0 {
                
                storage.setBool(false, forKey: "notification")
                
                let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                    }
                    
                    self.goToSettings = true
                    
                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                
                presentViewController(refreshAlert, animated: true, completion: nil)
                
            } else {
                
                sender.setTitle("ON", forState: .Normal)
                buttonTime.userInteractionEnabled = true
                buttonTime.alpha = 1
                atText.alpha = 1
                storage.setBool(true, forKey: "notification")
                
                notificatonScheduling()
            }
     
        }
        
    }
    
    func setTimeNotification(sender:UIButton!){
        
        NSUserDefaults.incrementIntegerForKey("timeNotification")
        
        if storage.integerForKey("timeNotification") >= 24{
            storage.setInteger(0, forKey: "timeNotification")
        }
        
        sender.setTitle("\(storage.valueForKey("timeNotification")!):00", forState: .Normal)
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        notificatonScheduling()
        
    }
    
    
    func notificatonScheduling() {
        
        let date2: NSDate = NSDate()
        let cal2: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let date19: NSDate = cal2.dateBySettingHour(storage.integerForKey("timeNotification"), minute: 0, second: 0, ofDate: date2, options: NSCalendarOptions())!
        let notification = UILocalNotification()
        notification.fireDate = date19
        notification.alertBody = "NOTIFICA DELLE 19"
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.repeatInterval = NSCalendarUnit.Day
        notification.userInfo = ["dailyNotification": "150UP"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    
    }
    
    
}

extension NSUserDefaults {
    class func incrementIntegerForKey(key:String) {
        let defaults = standardUserDefaults()
        let int = defaults.integerForKey(key)
        defaults.setInteger(int+1, forKey:key)
    }
}


