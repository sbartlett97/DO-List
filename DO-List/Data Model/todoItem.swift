//
//  todoItem.swift
//  DO-List
//
//  Created by Samuel Bartlett on 28/11/2018.
//  Copyright © 2018 Samuel Bartlett. All rights reserved.
//

import Foundation
class todoItem: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
    init (){}
    convenience init(text: String) {
        self.init()
        title = text
    }
}
