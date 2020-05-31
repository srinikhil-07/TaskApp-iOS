//
//  TaskViewController.swift
//  DatePicker
//
//  Created by sri-7348 on 5/25/20.
//  Copyright © 2020 Nikhi. All rights reserved.
//

import Foundation
import UIKit
///This View does the following in chronlogical order
/// 1. For a given date, loads array of tasks
/// 2. Updates tasks (i.e.,) Adds new tasks, deletes existing ones
/// 3. While returning back.quits, saves the array 'state' to defaults in the system
class TaskViewController: UITableViewController {
    var items = [String]()
    public var dateKey: Int = 0
    let defaults = UserDefaults.standard
    convenience init(time: Int) { //initialze with date key to look for in db
        self.init()
        dateKey = time
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tasks")
        tableView.sectionHeaderHeight = 50
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Task", style: .plain, target: self, action: #selector(self.insert))
        print("Time: \(dateKey)")
        loadTasks()
    }
    func loadTasks() {
        if let tasks = defaults.object(forKey: String(dateKey)) {
            if let tasksArray = tasks as? [String] {
                items = tasksArray
            } else {
                print("Tasks type error")
            }
        } else {
            print("No tasks for this date")
        }
    }
    /// 1. This method should have a textbox alert where we can add a text,
    /// 2. Ok button adds the task and 'Cancel' button does nothing
    @objc func insert() {
        print("Adding task action selected")
        let ac = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            if let newTask = answer.text {
                self.items.append(newTask)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.defaults.set(self.items, forKey: String(self.dateKey))
            }
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tasks")!
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    /// Specify row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
