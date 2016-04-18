//
//  Comment+CoreDataProperties.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 4/16/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Comment {

    @NSManaged var commentText: String?
    @NSManaged var postDate: String?
    @NSManaged var posterName: String?
    @NSManaged var posterPhoto: NSData?
    @NSManaged var post: MainPost?

}
