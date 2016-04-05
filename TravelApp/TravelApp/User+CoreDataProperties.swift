//
//  User+CoreDataProperties.swift
//  TravelApp
//
//  Created by Hans Hovanitz on 4/4/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var password: String?
    @NSManaged var photo: NSData?
    @NSManaged var posts: NSSet?

}
