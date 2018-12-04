//
//  todoItem.swift
//  DO-List
//
//  Created by Samuel Bartlett on 04/12/2018.
//  Copyright © 2018 Samuel Bartlett. All rights reserved.
//

import Foundation
import RealmSwift

class todoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects<Category>(fromType: Category.self, property: "items")
}
