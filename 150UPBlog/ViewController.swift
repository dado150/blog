//
//  ViewController.swift
//  150UPBlog
//
//  Created by DAdo150 on 5/21/16.
//  Copyright © 2016 150UP. All rights reserved.
//

import UIKit
import Spring
import Parse


class ViewController: UIViewController {
    @IBOutlet weak var heroImg: SpringImageView!
    @IBOutlet weak var titleLabel: SpringLabel!
    @IBOutlet weak var tagLAbel: SpringLabel!
    @IBOutlet weak var buttonLAbel: SpringButton!
    private var link: String?
    private var menu: Menu = Menu()
    
    let date: NSDate = NSDate()
    let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var tomorrow:NSDate!
    var newDate:NSDate!
    var dateTomorrow:NSDate!
    
    var positionImage:CGRect!
    
  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        heroImg.frame = CGRectMake((view.frame.size.width / 2) - 10, (view.frame.size.height / 2) - 10, 20, 20)
//        heroImg.layer.cornerRadius = heroImg.frame.size.width / 2

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positionImage = heroImg.frame
        
        tomorrow = cal.dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])!
        newDate = cal.startOfDayForDate(date)
        dateTomorrow = cal.startOfDayForDate(tomorrow)
        
        heroImg.frame = CGRectMake((view.frame.size.width / 2) - 10, (view.frame.size.height / 2) - 10, 20, 20)

        getPost()
        
        self.menu.view.frame.origin.x = self.menu.view.frame.origin.x - self.menu.view.frame.size.width
        self.menu.view.frame.size.width = 200
        self.menu.view.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.menu.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func linkButton(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: link!)!)
    }
    
    
    
//    @IBAction func openMenu(sender: UIScreenEdgePanGestureRecognizer) {
//        
//        if (sender.state == UIGestureRecognizerState.Changed) {
//            
//            var translation = sender.translationInView(self.view).x
//            
//                self.menu.view.frame.origin.x = translation - self.menu.view.frame.size.width
//            
//            if (translation > self.menu.view.frame.size.width) {
//                
//             self.menu.view.frame.origin.x = 0
//            }
//            
//            else{
//                self.menu.view.frame.origin.x = translation - self.menu.view.frame.size.width
//            
//            }
//        }
//    }

    
    
    
   
    
    func getPost()  {
        
        heroImg.frame = CGRectMake((view.frame.size.width / 2) - 10, (view.frame.size.height / 2) - 10, 20, 20)
        let query = Post.query()!
        
        query.whereKey("PublishDate", greaterThanOrEqualTo:newDate)
        query.whereKey("PublishDate", lessThan:dateTomorrow)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                
                if let objects = objects {
                    
                    (objects as? [Post])?.forEach({ (post) in
                        
                        print(post.PublishDate)
                        print(post.objectId)
                        print(post.HeroImg)
                        
                        self.titleLabel.text = post.Title
                        self.tagLAbel.text = "#" + post.tag
                        
                        self.link = post.URL
                        
                        post.HeroImg.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    let image = UIImage(data:imageData)
                                    
                                    self.heroImg.image = image
                                    self.heroImg.opacity = 0
                                    self.heroImg.duration = 2
                                    self.heroImg.animate()

                                    self.titleLabel.y = -20
                                    self.titleLabel.opacity = 0
                                    self.titleLabel.delay = 1.00
                                    self.titleLabel.animate()
                                    
                                    self.tagLAbel.y = -5
                                    self.tagLAbel.opacity = 0
                                    self.tagLAbel.delay = 1.10
                                    self.tagLAbel.animate()
                                    
                                    self.buttonLAbel.y = -25
                                    self.buttonLAbel.opacity = 0
                                    self.buttonLAbel.delay = 2.50
                                    self.buttonLAbel.animate()
                                    self.buttonLAbel.setTitle("Read", forState: .Normal)
                                
                                }
                            }
                        }
                    })
                    
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

}

//    func doTheMagic(){
//
//        let query = Post.query()!
//
//        query.whereKey("PublishDate", greaterThanOrEqualTo:newDate)
//        query.whereKey("PublishDate", lessThan:dateTomorrow)
//
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//
//            if error == nil {
//
//                print("Successfully retrieved \(objects!.count) scores.")
//
//                if let objects = objects {
//
//                    (objects as? [Post])?.forEach({ (post) in
//
//                        print(post.objectId)
//                        self.titleLabel.text = post.Title
//                        self.tagLabel.text = "#" + (post.tag)
//
//                        let userImageFile = post.HeroImg
//                        userImageFile.getDataInBackgroundWithBlock {
//                            (imageData: NSData?, error: NSError?) -> Void in
//                            if error == nil {
//                                if let imageData = imageData {
//
//                                    let image = UIImage(data:imageData)
//                                    self.bigImg.image = image
//
//                                    self.inAnimation()
//
//                                }
//                            }
//                        }
//                    })
//                }
//
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//
//    }

