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
    var translation: String?
    var hasSubregions: Bool {subregions.count > 0}
    var map: String?
    var downloadable: Bool { map == "yes" || (!hasSubregions && map != "no") }
    var subregions = [Region]()
    
    var net_id = ""
    
    func displayName()->String{
        let str = translation ?? name
        return str.prefix(1).capitalized + str.dropFirst()
    }
    
    func formatId()->String{
        var str = net_id
        if str.filter({$0=="_"}).count > 1 {
            let slices = str.split(separator: "_")
            var tmp = slices[1] + "_" + slices[0]
            for i in 2..<slices.count{
                tmp += "_" + slices[i]
            }
            str = String(tmp)
        }
        
        str =  str.prefix(1).capitalized + str.dropFirst()
        str += "_2.obf.zip"
        return str
    }
}

