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
        
        static func initFromTodoSwitch(isOn: Bool) -> Status {
            return isOn ? .done : .todo
        }
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
    enum StatusFilter: String {
        case todo = "todo"
        case done = "done"
        case all
    }
    let realm = try! Realm()
    var todos: [Todo]
    var titleFilter: String = "" {
        didSet {
            filterTodo(query: titleFilter, status: statusFilter)
        }
    }
    var statusFilter: StatusFilter = .todo {
        didSet {
            filterTodo(query: titleFilter, status: statusFilter)
        }
    }
    
    var notificationToken: NotificationToken? = nil
    weak var delegate: TodoModelDelegate?
    
    init() {
        let todoResults = realm.objects(Todo.self)
        todos = Array(todoResults)
        statusFilter = .todo
        
        notificationToken = todoResults.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial: print("initial")
            case .update(_, _, _, _):
                print("update")
                if let titleFilter = self?.titleFilter {
                    self?.filterTodo(query: titleFilter, status: self!.statusFilter)
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    private func filterTodo(query: String, status: StatusFilter) {
        let todos = query.isEmpty ? realm.objects(Todo.self) : realm.objects(Todo.self)
            .filter("title CONTAINS '\(query)'")
        
        self.todos = status != .all ? Array(todos.filter("_status == '\(status.rawValue)'")) : Array(todos)
        
        delegate?.todoDidChange!()
    }
    
    func addTodo(title: String) {
        let todo = Todo()
        todo.id = Todo.newID
        todo.title = title
        try! realm.write {
            realm.add(todo)
        }
    }
    
    func deleteTodo(todo: Todo) {
        try! realm.write {
            realm.delete(todo)
        }
    }
    
    func changeStatus(todo: Todo, status: Todo.Status) {
        try! realm.write {
            todo.status = status
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
