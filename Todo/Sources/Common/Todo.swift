//
//  Todo.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/04.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import Foundation
import RealmSwift


class Todo: Object {
    enum Status: String {
        case todo = "todo"
        case done = "done"
    }
    
    @objc dynamic var id = ""
    @objc dynamic var title: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var _status = Status.todo.rawValue
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var status: Status {
        get {
            return Status(rawValue: _status)!
        }
        set {
            _status = newValue.rawValue
        }
    }
    static var newID: String {
        return NSUUID().uuidString
    }
}

@objc protocol TodoModelDelegate: class {
    @objc optional func todoDidChange()
}

class TodoModel {
    let realm = try! Realm()
    var todos: [Todo]
    var titleFilter: String = "" {
        didSet {
            filterTodo(query: titleFilter)
        }
    }
    var notificationToken: NotificationToken? = nil
    weak var delegate: TodoModelDelegate?
    
    init() {
        let todoResults = realm.objects(Todo.self)
        todos = Array(todoResults)
        
        notificationToken = todoResults.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial: print("initial")
            case .update(_, _, _, _):
                print("update")
                if let titleFilter = self?.titleFilter {
                    self?.filterTodo(query: titleFilter)
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    func addTodo(title: String) {
        let todo = Todo()
        todo.id = Todo.newID
        todo.title = title
        try! realm.write {
            realm.add(todo)
        }
    }
    
    func filterTodo(query: String) {
        if query.isEmpty {
            todos = Array(
                realm.objects(Todo.self)
            )
        } else {
            todos = Array(
                realm.objects(Todo.self)
                    .filter("title CONTAINS '\(query)'")
            )
        }
        
        delegate?.todoDidChange!()
    }
    
    func deleteTodo(todo: Todo) {
        try! realm.write {
            realm.delete(todo)
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
