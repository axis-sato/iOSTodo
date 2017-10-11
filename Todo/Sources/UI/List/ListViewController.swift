//
//  ListViewController.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/03.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
        return searchBar
    }()
    
    private var todos: [Todo] = [] {
        didSet {
            filteredTodos = filterTodos(baseTodo: todos, query: query)
        }
    }
    private var filteredTodos: [Todo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var query: String = "" {
        didSet {
            filteredTodos = filterTodos(baseTodo: todos, query: query)
        }
    }
    private func filterTodos(baseTodo: [Todo], query: String) -> [Todo] {
        if (query.isEmpty) {
            return todos
        }
        return baseTodo.filter() {todo in
            return todo.title.contains(query)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
    }
}

private typealias Event = ListViewController
extension Event {
    @IBAction func didTapAddition(_ sender: Any) {
        showAdditionalAlertView()
    }
    
    private func showAdditionalAlertView() {
        let alert = UIAlertController(title: "TODO追加", message: "タイトルを入力してください。", preferredStyle: .alert)
        
        // OKボタンの設定
        let okAction = UIAlertAction(title: "追加", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let text = alert.textFields?.first?.text {
                let todo = Todo(title: text)
                self.todos.append(todo)
            }
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "タイトル"
        })
        
        alert.view.setNeedsLayout()
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
}

private typealias SearchBarDelegate = ListViewController
extension SearchBarDelegate: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        query = searchText
    }
}

private typealias TableViewDelegate = ListViewController
extension TableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: indexPath.rowはfilteredTodosの値なので正しいTodoが削除できない
            todos.remove(at: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = filteredTodos[indexPath.row]
        let vc = DetailViewController.getSelf(todo: todo)
        navigationController?.pushViewController(vc, animated: true)
    }
}

private typealias TableViewDataSource = ListViewController
extension TableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return todos.count
        return filteredTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = filteredTodos[indexPath.row].title
        return cell
    }
}
