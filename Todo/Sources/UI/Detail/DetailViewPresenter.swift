//
//  DetailViewPresenter.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/25.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import Foundation
import RealmSwift

protocol DetailPresenter: class {
    var title: String { get }
    var isStatuSwitchOn: Bool { get }
    func changeStatus(isOn: Bool)
}

final class DetailViewPresenter {
    let realm = try! Realm()
    private weak var view: DetailView?
    private let todo: Todo
    private let listPresenter: ListPresenter
    
    init(view: DetailView, todo: Todo, listPresenter: ListPresenter) {
        self.view = view
        self.todo = todo
        self.listPresenter = listPresenter
    }
}

// MARK: - DetailPresenter
extension DetailViewPresenter: DetailPresenter {
    var title: String {
        return todo.title
    }
    
    var isStatuSwitchOn: Bool {
        return todo.status == Todo.Status.done
    }
    
    func changeStatus(isOn: Bool) {
        let newStatus = Todo.Status.initFromTodoSwitch(isOn: isOn)
        try! realm.write {
            todo.status = newStatus
        }
    }
}
