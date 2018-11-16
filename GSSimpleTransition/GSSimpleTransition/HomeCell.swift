//
//  HomeCell.swift
//  GSSimpleTransition
//
//  Created by gina on 2018/11/16.
//  Copyright © 2018 gina. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInfo(info:Info) {
        itemImageView.image = UIImage(named: info.imageName)
        itemLabel.text = info.title
    }
}
