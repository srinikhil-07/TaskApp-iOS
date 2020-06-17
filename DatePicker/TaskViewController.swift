//
//  TaskViewController.swift
//  DatePicker
//
//  Created by Nikhil on 5/25/20.
//  Copyright © 2020 Nikhi. All rights reserved.
//

import Foundation
import UIKit
///This View does the following in chronlogical order
/// 1. For a given date, loads array of tasks
/// 2. Updates tasks (i.e.,) Adds new tasks, deletes existing ones
/// 3. While returning back.quits, saves the array 'state' to defaults in the system
class TaskViewController: UIViewController {
    var items = [taskItem]()
    enum Section: CaseIterable {
        case main
    }
    struct taskItem: Hashable { // models our task item
        let title: String
        private let identifier: UUID
        init(with title: String) {
            self.title = title
            self.identifier = UUID()
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.identifier)
        }
    }
    public var dateKey: Int = 0
    let defaults = UserDefaults.standard
    var dataSource: UITableViewDiffableDataSource<Section, taskItem>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, taskItem>! = nil
    let tableView = UITableView.init(frame: .zero, style: .plain)
    static let cellIdentifier: String = "tasks"
    // - MARK:
    convenience init(time: Int) { //initialze with date key to look for in db
        self.init()
        dateKey = time
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        print("Time: \(dateKey)")
        loadTasks()
        configureDataSource()
        updateUI()
    }
    func loadTasks() {
        if let tasks = defaults.object(forKey: String(dateKey)) {
            if let tasksArray = tasks as? [String] {
                items = self.tasks(for: tasksArray)
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
                self.items.append(taskItem.init(with: newTask))
                self.updateUI()
                self.defaults.set(self.tasksTitle(for: self.items), forKey: String(self.dateKey))
            }
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    /// Update UI using current snapshot
    func updateUI() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Section,taskItem>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(items, toSection: .main)
        self.dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    /// Configurinng our data source
    func configureDataSource() {
        //self.updateUI()
        self.dataSource = UITableViewDiffableDataSource<Section, taskItem>(tableView: tableView) { [weak self]
            (tableView: UITableView, indexPath: IndexPath, item: taskItem) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier:"tasks", for: indexPath)
            cell.textLabel?.text = self?.items[indexPath.row].title
            return cell
        }
    }
    /// Setup table view
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        /// - ToDo: Without constrait, tableview wasnt showed. Check why
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.tableView.rowHeight = 65
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tasks")
        tableView.sectionHeaderHeight = 50
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Task", style: .plain, target: self, action: #selector(self.insert))
    }
    /// Return tasks title array for tasks array
    func tasksTitle(for tasks: [taskItem]) -> [String] {
        let titles = tasks.map {
            return $0.title
        }
        return titles
    }
    /// Get taks items from titles
    func tasks(for titles: [String]) -> [taskItem]{
        let tasks = titles.map {
            return taskItem.init(with: $0)
        }
        return tasks
    }
}
