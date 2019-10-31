//
//  RegionCell.swift
//  SaveTheMap
//
//  Created by Artem Martus on 30.10.2019.
//  Copyright © 2019 Artem Martus. All rights reserved.
//

import UIKit

class RegionCell: UITableViewCell{
    private var progressView: UIProgressView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(item: Region!){
        var hide = true
        if item.isDownloading && item.downloadProgress < 1.0 {
            progressView.progress = Float(item.downloadProgress)
            hide = false
        }
        
        if progressView.isHidden != hide {
            progressView.isHidden = hide
        }
    }
    
    func commonInit(){
        accessoryView = nil
        accessoryType = .none
        progressView = UIProgressView()
        progressView.progress = 0
        progressView.isHidden = true
        //        progressView.progressTintColor = UIColor.blue //UIColor(named: "NavBarTint")
        //        progressView.trackTintColor = UIColor(named: "Background")
        progressView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: CGFloat(-4)),
            progressView.leftAnchor.constraint(
                equalTo: textLabel!.leftAnchor),
            progressView.widthAnchor.constraint(
                equalTo: textLabel!.widthAnchor)
        ])
    }
}
