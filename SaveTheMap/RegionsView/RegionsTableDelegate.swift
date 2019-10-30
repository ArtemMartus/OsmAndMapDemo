//
//  RegionsTableDelegate.swift
//  SaveTheMap
//
//  Created by Artem Martus on 30.10.2019.
//  Copyright © 2019 Artem Martus. All rights reserved.
//

import UIKit

class RegionsTableDelegate:NSObject,UITableViewDelegate, UITableViewDataSource{
    weak var rootView: RegionsView?
    var region: Region!
    var showMemory = true
    
    init(view:RegionsView, region: Region, showMemory: Bool) {
        self.rootView = view
        self.region = region
        self.showMemory = showMemory
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showMemory && section == 0 {
            return 1
        }
        return region.subregions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        showMemory ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if showMemory && section == 0 {
            return nil
        }
        
        return region.name.capitalized
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && showMemory {
            return tableView.dequeueReusableCell(withIdentifier: "memory") as! FreeMemoryView
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "regular")!
        
        let item = region.subregions[indexPath.row]
        cell.textLabel?.text = item.displayName()
        cell.imageView?.image = UIImage(named: "ic_custom_show_on_map")!.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = UIColor.gray
        if item.downloadable {
            if Repository.shared.checkMapDownloaded(id: item.formatId()) {
                cell.accessoryView = nil
                cell.imageView?.tintColor = UIColor.green
//                print("Item \(item.formatId()) downloaded")
            } else {
                cell.accessoryView = UIImageView(image: UIImage(named: "ic_custom_import"))
            }
        } else if item.hasSubregions {
            let image = UIImageView(image: UIImage(systemName: "chevron.right"))
            image.tintColor = .gray
            cell.accessoryView =  image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && showMemory {
            let item = region.subregions[indexPath.row]
            
            if item.downloadable {
                //should check if already downloaded
                Repository.shared.placeMapInDownloadQueue(id: item.formatId()) { progress in
                    print("Callback progress = \(progress.fractionCompleted*100)")
                }
            } else if item.hasSubregions {
                let viewController = RegionsView(region: item)
                viewController.showMemory = false
                rootView?.navigationController?
                    .pushViewController(viewController, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
