//
//  Region.swift
//  SaveTheMap
//
//  Created by Artem Martus on 30.10.2019.
//  Copyright © 2019 Artem Martus. All rights reserved.
//

import Foundation

class Region{
    var name = ""
    var hasSubregions = false
    var map = "no"
    var downloadable: Bool { map == "yes" }
    var subregions = [Region]()
}

