//
//  ActivityViewCell.swift
//  Stagram
//
//  Created by Juliang Li on 2/27/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit

class ActivityViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
