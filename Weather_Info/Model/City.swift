//
//  City.swift
//  Weather_Info
//
//  Created by Ahmad Hussain Zamee on 9/9/19.
//  Copyright © 2019 Ahmad Hussain Zamee. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var lat = 0.0
    @objc dynamic var lng = 0.0
}

