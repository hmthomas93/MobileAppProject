//
//  MainPost+CoreDataProperties.swift
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

extension MainPost {

    @NSManaged var attraction: String?
    @NSManaged var city: String?
    @NSManaged var commentText: String?
    @NSManaged var placePhoto: NSData?
    @NSManaged var postDate: String?
    @NSManaged var state: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var comments: NSSet?
    @NSManaged var poster: User?

}
