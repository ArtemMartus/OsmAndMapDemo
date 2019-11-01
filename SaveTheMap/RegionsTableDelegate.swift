//
//  RegionsTableDelegate.swift
//  SaveTheMap
//
//  Created by Artem Martus on 30.10.2019.
//  Copyright © 2019 Artem Martus. All rights reserved.
//

import UIKit
import Dispatch

let RegionCellID = "regular"
let FreeMemoryID = "memory"

class RegionsTableDelegate:NSObject,UITableViewDelegate, UITableViewDataSource {
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
            return tableView.dequeueReusableCell(
                withIdentifier: FreeMemoryID) as! FreeMemoryView
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RegionCellID, for: indexPath) as! RegionCell
        let item = region.subregions[indexPath.row]
        let progress = Repository.shared.downloadProgress[item.net_id]
        let isDownloading = progress != nil
        
        
        cell.setProgress(item: item)
        cell.textLabel?.text = item.displayName()
        cell.imageView?.image = UIImage(named: "ic_custom_show_on_map")!.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = UIColor.gray
        
        if item.downloadable ?? (!item.hasSubregions) {
            if !isDownloading && Repository.shared.checkMapDownloaded(id: item.formatId()) {
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && showMemory || !showMemory {
            let item = region.subregions[indexPath.row]
            let repo = Repository.shared
            let isDownloading = repo.downloadProgress[item.net_id] != nil
            
            if isDownloading || Repository.shared.checkMapDownloaded(id: item.formatId()) {
                return // if we have any progress - no tap handling required
            }
            
            if item.downloadable ?? !item.hasSubregions {
                repo.downloadProgress[item.net_id] = 0
                // set downloadProgress to some minimum value just
                // for progress view to appear before real download starts
                // in case we have other downloads in queue so user knows
                // something is happening
                Repository.shared.placeMapInDownloadQueue(id: item.formatId(), progress: { progress in
                    //                    print("download progress \(value)")
                    DispatchQueue.main.async {
                        repo.downloadProgress[item.net_id] = progress.fractionCompleted
                        if let cell = self.rootView?.tableView.cellForRow(at: indexPath)
                            , let regular = cell as? RegionCell {
                            regular.setProgress(item: item)
                        }
                    }
                }, done: { result in
                    DispatchQueue.main.async {
                        repo.downloadProgress.removeValue(forKey: item.net_id)
                        print("done called")
                        self.rootView?.tableView.reloadData()
                    }
                })
                tableView.reloadData()

            } else if item.hasSubregions {
                let viewController = RegionsView(region: item)
                viewController.showMemory = false
                rootView?.navigationController?
                    .pushViewController(viewController, animated: true)
            }
        }
    }
}
