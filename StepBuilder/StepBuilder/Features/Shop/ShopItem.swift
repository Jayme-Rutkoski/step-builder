//
//  ShopItem.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/8/25.
//

import Foundation
import UIKit

class ShopItem {
    var name: String
    var price: Int
    var image: UIImage?
    
    init(name: String, price: Int, image: UIImage?) {
        self.name = name
        self.price = price
        self.image = image
    }
}
