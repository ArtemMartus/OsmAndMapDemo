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
    override func viewDidLoad() {
        delegate = RegionsTableDelegate(view: self)
        
        title = "Download Maps"
        view.backgroundColor = UIColor(named: "Background")
        tableView.separatorColor = UIColor(named: "Separator")
        tableView.dataSource = delegate
        tableView.delegate = delegate
        tableView.register(FreeMemoryView.self, forCellReuseIdentifier: "memory")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "regular")
        setupLayout()
    }
    
    func setupLayout(){
    }
}
