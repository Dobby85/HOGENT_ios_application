//
//  TypeModel.swift
//  WineShop
//
//  Created by Maxime Magné on 26/11/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit

struct TypeModel:Decodable {
    var id: Int
    var type: String
    var label: String
    var labelSubType: String
    var vat: VatModel
    var multiple: Int
}
