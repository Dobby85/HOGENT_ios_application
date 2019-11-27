//
//  WineTableViewCell.swift
//  WineShop
//
//  Created by Maxime Magné on 18/11/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit

class WineTableViewCell: UITableViewCell {
    
    @IBOutlet var WineImage: UIImageView!
    @IBOutlet var WineName: UILabel!
    @IBOutlet var WinePrice: UILabel!
    @IBOutlet var WineDescription: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
