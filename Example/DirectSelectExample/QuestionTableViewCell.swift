//
//  QuestionTableViewCell.swift
//  CustomSelector_Example
//
//  Created by swasidhant chowdhury on 12/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
