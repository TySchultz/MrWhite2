//
//  LeaderBoardCell.swift
//  MrWhite2
//
//  Created by Ty Schultz on 10/26/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

class LeaderBoardCell: UITableViewCell {

  
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var initials: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
