//
//  Todo.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/04.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import Foundation

struct Todo {
    enum Status {
        case done, todo
    }
    
    var status = Status.todo
    var title: String
    
    init(title: String, description: String) {
        self.title = title
    }
}
