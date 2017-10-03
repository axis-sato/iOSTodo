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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
    }
}

private typealias Event = ListViewController
extension Event {
    @IBAction func didTapAddition(_ sender: Any) {
        print("add todo")
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
            print("delete")
        }
    }
}

private typealias TableViewDataSource = ListViewController
extension TableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "foo"
        return cell
    }
}
