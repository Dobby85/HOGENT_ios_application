//
//  UIImageViewExtension.swift
//  WineShop
//
//  Created by Maxime Magné on 27/11/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit

// SOURCE: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data.init(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        print("SET IMAGE")
                        self?.image = image
                    }
                }
            }
        }
    }
}
