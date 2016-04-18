//
//  MasterData.swift
//  TravelApp
//
//  Created by Alison Saunders on 4/4/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import Foundation

import Foundation

class MasterData {
    class var sharedInstance: MasterData {
        struct Static {
            static let instance = MasterData()
        }
        return Static.instance
    }
    
    var currentUserProfile : User? = nil
}