//
//  ListViewController.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/03.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import UIKit

protocol ListView: class {
    func reloadData()
    func showDetailView(todo: Todo)
}


class ListViewController: UIViewController {
    private(set) lazy var presenter: ListPresenter = ListViewPresenter(view: self)
    
    private lazy var dataSource: ListViewDataSource = .init(presenter: self.presenter)
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
        return searchBar
    }()
}

// MARK: - Life cycle
extension ListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configure(tableView: tableView)
        
        navigationItem.titleView = searchBar
    }
}


// MARK: - ListView
extension ListViewController: ListView {
    func reloadData() {
        tableView.reloadData()
    }
    
    func showDetailView(todo: Todo) {
        let vc = DetailViewController.initFromStoryboard(
            todo: todo,
            listPresenter: presenter
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - IBAction
extension ListViewController {
    @IBAction func didTapAddition(_ sender: Any) {
        func showAdditionalAlertView() {
            let alert = UIAlertController(title: "TODO追加", message: "タイトルを入力してください。", preferredStyle: .alert)
            
            // OKボタンの設定
            let okAction = UIAlertAction(title: "追加", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                
                if let text = alert.textFields?.first?.text {
                    self.presenter.add(title: text)
                }
            })
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                textField.placeholder = "タイトル"
            })
            
            alert.view.setNeedsLayout()
            self.present(alert, animated: true, completion: nil)
        }
        showAdditionalAlertView()
    }
    
    @IBAction func didChangeStatus(_ sender: Any) {
        let s = sender as! UISegmentedControl
        presenter.changeFilterStatus(at: s.selectedSegmentIndex)
    }
}

// MARK: - SearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(searchText: searchText)
    }
}
