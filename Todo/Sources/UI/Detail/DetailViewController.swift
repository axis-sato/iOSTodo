//
//  DetailViewController.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/06.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import UIKit

protocol DetailView: class {
    
}

class DetailViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var statusSwitch: UISwitch!
    
    // MARK: property
    private var presenter: DetailPresenter!
    
    // MARK: initFromStoryboard
    static func initFromStoryboard(todo: Todo, listPresenter: ListPresenter) -> DetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        vc.presenter = DetailViewPresenter(
            view: vc,
            todo: todo,
            listPresenter: listPresenter)
        return vc
    }
}

// MARK: - Life cycle
extension DetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = presenter.title
        statusSwitch.isOn = presenter.isStatuSwitchOn
    }
}

// MARK: - IBAction
extension DetailViewController {
    @IBAction func didChangeStatusSwitch(_ sender: Any) {
        let s = sender as! UISwitch
        presenter.changeStatus(isOn: s.isOn)
    }
}

extension DetailViewController: DetailView {
    
}
