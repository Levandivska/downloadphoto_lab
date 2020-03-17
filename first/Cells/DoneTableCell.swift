//
//  DoneTableCell.swift
//  first
//
//  Created by оля on 3/9/20.
//  Copyright © 2020 Olya. All rights reserved.
//

import UIKit

class DoneTableCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
//    var mainImageView : UIImageView  = {
//        var imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    
//    var imageViewHeight = NSLayoutConstraint()
//    var imageRatioWidth = CGFloat()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.addSubview(mainImageView)
//        
//        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//
//    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func customInit(text: String){
        self.title.text = text
    }

    
}
