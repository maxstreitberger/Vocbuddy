//
//  TopicsTableViewCell.swift
//  vocbuddy
//
//  Created by Max Streitberger on 24.11.19.
//  Copyright © 2019 Max Streitberger. All rights reserved.
//

import UIKit

class TopicsTableViewCell: UITableViewCell {
    
    let topicNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectionIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "unselected_icon")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(r: 255, g: 114, b: 0)
        
        setUpCell()
    }
    
    func setUpCell() {
        self.addSubview(topicNameLabel)
        topicNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topicNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(selectionIndicator)
        selectionIndicator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        selectionIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        selectionIndicator.heightAnchor.constraint(equalToConstant: 28).isActive = true
        selectionIndicator.widthAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
