//
//  FreeMemoryView.swift
//  SaveTheMap
//
//  Created by Artem Martus on 30.10.2019.
//  Copyright © 2019 Artem Martus. All rights reserved.
//

import UIKit

class FreeMemoryView: UITableViewCell {
    var vstack: UIStackView!
    var hstack: UIStackView!
    var freeMemory: UILabel!
    var progressView: UIProgressView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(){
//        let container = UIView()
        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        var gb:Float!
        var overallMemory: Float!
        
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey,.volumeAvailableCapacityKey])
            overallMemory = Float(values.volumeTotalCapacity!)/(1024*1024*1024)
            gb = Float(values.volumeAvailableCapacity!)/(1024*1024*1024)
        } catch {
            fatalError("Error retrieving capacity: \(error.localizedDescription)")
        }
        
        contentView.backgroundColor = UIColor(named: "CellBackground")
        let deviceMemory = UILabel()
        
        deviceMemory.text = "Device memory"
        freeMemory = UILabel()
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        freeMemory.text = "Free \(formatter.string(for:gb)!) Gb"
        freeMemory.textAlignment = .right
        progressView = UIProgressView()
        
        progressView.progress = (overallMemory - gb) / overallMemory
        progressView.progressTintColor = UIColor(named: "NavBarTint")
        progressView.trackTintColor = UIColor(named: "Background")
        progressView.layer.cornerRadius = 8
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 8
        progressView.subviews[1].clipsToBounds = true
        
        hstack = UIStackView(arrangedSubviews: [deviceMemory,freeMemory])
        hstack.axis = .horizontal
        hstack.distribution = .fillEqually
        vstack = UIStackView(arrangedSubviews: [hstack,progressView])
        vstack.axis = .vertical
        vstack.distribution = .fillEqually
        vstack.spacing = CGFloat(8)
//        container.addSubview(vstack)
        contentView.addSubview(vstack)
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(16)),
            vstack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: CGFloat(-16)),
            vstack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: CGFloat(16)),
            vstack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CGFloat(-16)),
        ])
    }
}
