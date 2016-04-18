//
//  MainPost.swift
//  TravelApp
//
//  Created by Hailee Thomas on 4/17/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import Foundation
import CoreData


class MainPost: NSManagedObject {
    
    @NSManaged var attraction : String?
    @NSManaged var city : String?
    @NSManaged var commentText : String?
    @NSManaged var placePhoto : NSData?
    @NSManaged var postDate : String?
    @NSManaged var state : String?

}