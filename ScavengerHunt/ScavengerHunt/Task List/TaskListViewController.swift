//
//  TaskListViewController.swift
//  ScavengerHunt
//
//  Created by Topu Saha on 2/27/24.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDataSource {
   
    var tasks: [Task] = [
        Task(name: "Find the Specialized Services Office", completed: false),
        Task(name: "Find the Science Building Room 150", completed: false),
        Task(name: "Find the career center in S150", completed: false)
    ]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = taskList.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        cell.task.text = tasks[indexPath.row].name
        
        
        return cell
        
    }
    
    

    @IBOutlet weak var taskList: UITableView!
    
   
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        
        taskList.dataSource = self
        
        
    }

    
}
