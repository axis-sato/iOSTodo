//
//  DetailViewController.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/06.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var statusSwitch: UISwitch!
    
    // MARK: - property
    var todo: Todo!
    var todoModel: TodoModel!
    
    // MARK: - initFromStoryboard
    static func initFromStoryboard(todo: Todo, todoModel: TodoModel) -> DetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        vc.todo = todo
        vc.todoModel = todoModel
        return vc
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = todo.title
        statusSwitch.isOn = todo.status == Todo.Status.done
    }
    
    // MARK: - IBAction
    @IBAction func didChangeStatusSwitch(_ sender: Any) {
        let s = sender as! UISwitch
        let newStatus = Todo.Status.initFromTodoSwitch(isOn: s.isOn)
        todoModel.changeStatus(todo: todo, status: newStatus)
    }
}
