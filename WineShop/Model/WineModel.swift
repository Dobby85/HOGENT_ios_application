//
//  WineModel.swift
//  WineShop
//
//  Created by Maxime Magné on 18/11/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit
import CoreData

struct WineModel:Decodable {
    var id: Int
    var name: String
    var description: String
    var image: String
    var year: Int
    var price: Float
    var subtype: SubTypeModel
}
