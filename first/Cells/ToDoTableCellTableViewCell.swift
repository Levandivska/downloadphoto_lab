//
//  ToDoTableCellTableViewCell.swift
//  first
//
//  Created by оля on 3/9/20.
//  Copyright © 2020 Olya. All rights reserved.
//

import UIKit

class ToDoTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customInit(text: String){
        self.titleLabel.text = text
    }
    
}
