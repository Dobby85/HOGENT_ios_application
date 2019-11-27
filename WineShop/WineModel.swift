//
//  WineModel.swift
//  WineShop
//
//  Created by Maxime Magné on 18/11/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit

struct WineModel:Decodable {
    var id: Int
    var name: String
    var description: String
    var image: String
    var year: Int
    var isValid: Bool
    var sellByMultipleOf: Int
    var dateCreated: String
    var dateDeleted: String?
    var idSite: Int
    var price: Float
    var type: TypeModel
    var subtype: SubTypeModel
}
