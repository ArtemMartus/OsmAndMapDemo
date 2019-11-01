//
//  Repository.swift
//  SaveTheMap
//
//  Created by Artem Martus on 30.10.2019.
//  Copyright © 2019 Artem Martus. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import Alamofire
import Dispatch

class Repository {
    static var shared: Repository = {
        let instance = Repository()
        return instance
    }()
    
    var region: Region!
    
    func checkMapDownloaded(id filename: String)->Bool{
        let fileManager = FileManager.default
        let filePath = fileManager.urls(for:
            .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = filePath
            .appendingPathComponent(filename,isDirectory: false)
        do {
            if try fileUrl.checkResourceIsReachable() {
                //                print("FILE \(filename) AVAILABLE")
                return true
            }
        } catch{
            //            print("Error? \(error.localizedDescription)")
        }
        return false
    }
    
    typealias ProgressCallback =  (Progress)->Void
    typealias DoneCallback = (Bool)->Void
    
    private var downloadQueue = [(String, ProgressCallback, DoneCallback)]()
    
    func placeMapInDownloadQueue(id: String!,progress:@escaping ProgressCallback, done: @escaping DoneCallback){
        
        if downloadQueue.isEmpty {
            downloadQueue.append((id,progress,done))
            download()
        } else {
            downloadQueue.append((id,progress,done))
        }
    }
    
    private func sequentialDownload(done: DoneCallback, value: Bool){
        done(value)
        if downloadQueue.count > 0 {
            download()
        }
    }
    
    private func download(){
        let (id,progress,done) = downloadQueue.first!
        
        let manager = Alamofire.SessionManager.default
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(id)
            //            print(documentsURL)
            return (documentsURL, [.createIntermediateDirectories])
        }
        
        manager.download((self.base_url) + id, to: destination)
            
            .downloadProgress(closure: progress)
            .validate { request, response, temporaryURL, destinationURL in
                print("Validate: success")
                return .success
        }
            
        .responseData { response in
            if let destinationUrl = response.destinationURL {
                print(destinationUrl)
                
                if let statusCode = (response.response)?.statusCode {
                    print("Success: \(statusCode)")
                    self.downloadQueue.removeFirst()
                    self.sequentialDownload(done:done,value:true)
                }
                
            } else {
                print("Response url-optional check failed")
            }
        }
    }
    
    
    private let base_url = "http://dl2.osmand.net/download?standard=yes&file="
    
    private func formRegion(data: XML.Element,parentId: String)->Region{
        let region = Region()
        region.name = data.attributes["name"]!
        if region.name == "europe" { region.net_id = "europe" } else {
            region.net_id = region.name + "_" + parentId
        }
        if let map = data.attributes["map"] {
            if map == "yes" {
                region.downloadable = true
            } else if map == "no" {
                region.downloadable = false
            }
        }
        if let tr = data.attributes["translate"] {
            var tmp = String(tr.split(separator: ";")[0])
            if tmp.contains("=") {
                let ar = tmp.split(separator: "=")
                tmp = String(ar.last!)
            }
            region.translation = tmp
        }
        
        for subregion in data.childElements {
            let child = formRegion(data: subregion,parentId: region.net_id)
            region.subregions.append(child)
        }
        
        return region
    }
    
    private init(){
        if let path = Bundle.main.url(forResource: "regions", withExtension: "xml"){
            let xml = XML.parse(try! Data(contentsOf: path)) ["regions_list"].element!
            
            for i in xml.childElements {
                if i.attributes["name"]! == "europe" {
                    region = formRegion(data: i,parentId: "")
                }
            }
            
        }
    }
    
}
