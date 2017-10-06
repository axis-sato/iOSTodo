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
            tableView.reloadData()
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
        let todo = Todo(title: "title\(todos.count)")
        todos.append(todo)
    }
}

private typealias SearchBarDelegate = ListViewController
extension SearchBarDelegate: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

private typealias TableViewDelegate = ListViewController
extension TableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        let vc = DetailViewController.getSelf(todo: todo)
        navigationController?.pushViewController(vc, animated: true)
    }
}

private typealias TableViewDataSource = ListViewController
extension TableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = todos[indexPath.row].title
        return cell
    }
}
