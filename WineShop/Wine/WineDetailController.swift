//
//  WineDetailController.swift
//  WineShop
//
//  Created by Maxime Magné on 06/12/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit

class WineDetailController: UIViewController {
    @IBOutlet var WineImage: UIImageView!
    @IBOutlet var WineName: UILabel!
    @IBOutlet var WinePrice: UILabel!
    @IBOutlet var WineDescription: UILabel!
    
    var wine: WineModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let wine = wine {
            WineName.text = wine.subtype.label
            WineDescription.text = wine.subtype.description
            WineImage.load(url: URL(string: "http://hearthjs.io:8082/image/\(wine.image)")!)
            WinePrice.text = String(wine.price) + "€"
        }
    }
}
