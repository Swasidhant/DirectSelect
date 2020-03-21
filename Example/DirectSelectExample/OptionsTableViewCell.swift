//
//  OptionsTableViewCell.swift
//  CustomSelector_Example
//
//  Created by swasidhant chowdhury on 12/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DirectSelect

class OptionsTableViewCell: UITableViewCell {
    
    var dataModel: DSDataModel?
    var initialView: UIView?
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }
    
    private func addShadow() {
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        containerView.layer.shadowRadius = 5.0
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        containerView.layer.cornerRadius = 6.0
    }
    
    func initialseInitialView() {
        if self.initialView == nil {
            self.initialView = DSInitialView.createInstance(model: self.dataModel!, delegate: nil)
            self.initialView?.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.addSubview(self.initialView!)
            self.addRequiredConstraints()
        }
    }
    
    private func addRequiredConstraints() {
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.initialView!])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.initialView!])
        
        self.containerView.addConstraints(horizontalConstraints)
        self.containerView.addConstraints(verticalConstraints)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
