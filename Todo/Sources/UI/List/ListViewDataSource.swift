//
//  ListViewDataSource.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/25.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import Foundation
import UIKit

final class ListViewDataSource: NSObject {
    private let presenter: ListPresenter
    
    init(presenter: ListPresenter) {
        self.presenter = presenter
    }
    
    func configure(tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

extension ListViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfTodos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        let todo = presenter.todo(at: indexPath.row)
        cell.textLabel?.text = todo.title
        return cell
    }
}

extension ListViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.delete(at: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetail(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
