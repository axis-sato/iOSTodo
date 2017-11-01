//
//  ListViewPresenter.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/24.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import Foundation
import RealmSwift

protocol ListPresenter: class {
    var numberOfTodos: Int { get }
    func todo(at index: Int) -> Todo
    func add(title: String)
    func search(searchText: String)
    func changeFilterStatus(at index: Int)
    func delete(at index: Int)
    func showDetail(at index: Int)
}

final class ListViewPresenter {
    private weak var view: ListView?
    private let realm: Realm
    private var notificationToken: NotificationToken!
    private lazy var todos: [Todo] = Array(realm.objects(Todo.self))
    private var query: String = "" {
        didSet {
            filterTodo(query: query, status: statusFilter)
        }
    }
    private var statusFilter: StatusFilter = .todo {
        didSet {
            filterTodo(query: query, status: statusFilter)
        }
    }
    
    init(view: ListView, realm: Realm) {
        self.view = view
        self.realm = realm
        
        self.initRealmNotification()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

// MARK: - ListPresenter
extension ListViewPresenter: ListPresenter {
    var numberOfTodos: Int {
        return todos.count
    }
    
    func todo(at index: Int) -> Todo {
        return todos[index]
    }
    
    func add(title: String) {
        let todo = Todo()
        todo.id = Todo.newID
        todo.title = title
        try! realm.write {
            realm.add(todo)
        }
        view?.reloadData()
    }
    
    func search(searchText: String) {
        query = searchText
    }
    
    func changeFilterStatus(at index: Int) {
        let status: [StatusFilter] = [.todo, .done, .all]
        statusFilter = status[index]
    }
    
    func delete(at index: Int) {
        let t = todo(at: index)
        try! realm.write {
            realm.delete(t)
        }
    }
    
    func showDetail(at index: Int) {
        let t = todo(at: index)
        view?.showDetailView(todo: t)
    }
}

// MARK: - Todo
extension ListViewPresenter {
    enum StatusFilter: String {
        case todo = "todo"
        case done = "done"
        case all
    }
    
    private func initRealmNotification() {
        notificationToken = realm.objects(Todo.self).observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial: print("initial")
            case .update(_, _, _, _):
                print("update")
                if let titleFilter = self?.query {
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
        
        view?.reloadData()
    }
}
