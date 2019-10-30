//
//  RegionsTableDelegate.swift
//  SaveTheMap
//
//  Created by Artem Martus on 30.10.2019.
//  Copyright © 2019 Artem Martus. All rights reserved.
//

import UIKit

class RegionsTableDelegate:NSObject,UITableViewDelegate, UITableViewDataSource{
    weak var view:RegionsView?
    init(view:RegionsView) {
        self.view = view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "EUROPE"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "memory") as! FreeMemoryView
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "regular")!
        cell.textLabel?.text = "hello"
        return cell
    }
    
    
}
