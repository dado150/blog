//
//  Post.swift
//  150UPBlog
//
//  Created by DAdo150 on 5/23/16.
//  Copyright © 2016 150UP. All rights reserved.
//

import Parse

class Post: PFObject, PFSubclassing {
    
    @NSManaged var HeroImg: PFFile
    @NSManaged var PublishDate: NSDate
    @NSManaged var Title: String
    @NSManaged var tag: String
    @NSManaged var URL: String
    
    static func parseClassName() -> String {
        return "Post"
    }
}