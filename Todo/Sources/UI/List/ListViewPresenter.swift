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
    func search(searchText: String)
}

final class ListViewPresenter: ListPresenter {
    private weak var view: ListView?
    private let realm = try! Realm()
    var todos: [Todo]
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
    
    init(view: ListView) {
        self.view = view
        
        let todoResults = realm.objects(Todo.self)
        todos = Array(todoResults)
    }
    
    func search(searchText: String) {
        query = searchText
    }
}

// MARK: - Todo
extension ListViewPresenter {
    enum StatusFilter: String {
        case todo = "todo"
        case done = "done"
        case all
    }
    
    private func filterTodo(query: String, status: StatusFilter) {
        let todos = query.isEmpty ? realm.objects(Todo.self) : realm.objects(Todo.self)
            .filter("title CONTAINS '\(query)'")
        
        self.todos = status != .all ? Array(todos.filter("_status == '\(status.rawValue)'")) : Array(todos)
        
        view?.reloadData()
    }
}
