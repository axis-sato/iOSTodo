//
//  DetailViewController.swift
//  Todo
//
//  Created by Masahiko Sato on 2017/10/06.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var todo: Todo!
    
    static func getSelf(todo: Todo) -> DetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        vc.todo = todo
        return vc
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = todo.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
