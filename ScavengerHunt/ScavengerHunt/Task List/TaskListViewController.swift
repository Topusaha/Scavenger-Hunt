//
//  TaskListViewController.swift
//  ScavengerHunt
//
//  Created by Topu Saha on 2/27/24.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDataSource {
   
    var tasks: [Task] = [
        Task(name: "Specialized Services Office", completed: false, description: "Find the Specialized Services Office in the K building and take a picture with Ms. Rak"),
        Task(name: "Science Building 150", completed: false, description: "Go into the science building and find room 150 which is a student lounge for STEM students"),
        Task(name: "Career Center", completed: false, description: "Find the career center in S150 and take a picture with one of the career advisors")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedIndexPath = taskList.indexPathForSelectedRow else { return }

        let selectedTask = tasks[selectedIndexPath.row]
        
        guard let detailViewController = segue.destination as? TaskDetailViewController else { return }

        detailViewController.task = selectedTask

    }

    
}
