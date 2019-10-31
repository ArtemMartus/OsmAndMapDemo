//
//  RegionsView.swift
//  SaveTheMap
//
//  Created by Artem Martus on 30.10.2019.
//  Copyright © 2019 Artem Martus. All rights reserved.
//

import UIKit

class RegionsView: UITableViewController{
    var delegate: RegionsTableDelegate!
    var region: Region!
    var showMemory = true
    

    init(region: Region) {
        super.init(style: .grouped)
        self.region = region
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        delegate = RegionsTableDelegate(view: self,region: region,showMemory: showMemory)
        
        title = "Download Maps"
        view.backgroundColor = UIColor(named: "Background")
        tableView.separatorColor = UIColor(named: "Separator")
        tableView.dataSource = delegate
        tableView.delegate = delegate
        tableView.register(FreeMemoryView.self, forCellReuseIdentifier: FreeMemoryID)
        tableView.register(RegionCell.self, forCellReuseIdentifier: RegionCellID)
    }
}
