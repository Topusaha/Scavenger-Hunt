//
//  TaskListViewController.swift
//  ScavengerHunt
//
//  Created by Topu Saha on 2/27/24.
//

import UIKit

class TaskListViewController: UIViewController {
    

    @IBOutlet weak var taskList: UITableView!
    
    var tasks = [Task]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}
