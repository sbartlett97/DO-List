//
//  Category.swift
//  DO-List
//
//  Created by Samuel Bartlett on 04/12/2018.
//  Copyright © 2018 Samuel Bartlett. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<todoItem>()
}
