//
//  ViewController.swift
//  DatePicker
//
//  Created by sri-7348 on 5/24/20.
//  Copyright © 2020 Nikhi. All rights reserved.
//

import UIKit
/// 1. Set Root view controller,
/// 2. Using autolayout, set datepicker in the view
/// 3. Using autolayout, set the 'Add Task' button as well and add action,
/// 4. Perform segue when button is clicked by passing selected date to next view
class DateSelector: UIViewController {
    var dateSelected = Date()
    weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        navigationItem.title = "Select Date"
        view.backgroundColor = .systemBackground
        setupView()
    }
    func setupView() {
        print("Setting up view")
        ///http://swiftdeveloperblog.com/code-examples/create-uidatepicker-programmatically/
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 250, width: self.view.frame.width, height: 200))
        datePicker.datePickerMode = .date
        datePicker.addTarget(self,action: #selector(dateAction), for: .valueChanged)
        self.view.addSubview(datePicker)
        let addTask = UIButton()
        addTask.setTitle("Add Task", for: .normal)
        addTask.frame = CGRect(x: 0, y: 600, width: self.view.frame.width, height: 10)
        addTask.setTitleColor(.systemBlue, for: .normal)
        addTask.addTarget(self, action: #selector(buttonAction), for: .touchDown)
        self.view.addSubview(addTask)
    }
    @objc func dateAction(_ sender: UIDatePicker) {
        dateSelected = sender.date
        print("Date selected: \(dateSelected.timeIntervalSince1970)")
    }
    @objc func buttonAction() {
        print("Button pressed for date: \(dateSelected.timeIntervalSince1970)")
        let dateKey = dateSelected.timeIntervalSince1970 - getDateStamp(for: dateSelected) //get key unique for a date
        print("Date key: \(dateKey)")
        ///https://stackoverflow.com/questions/39450124/swift-programmatically-navigate-to-another-view-controller-scene
        self.navigationController?.pushViewController(TaskViewController.init(time: Int(dateKey)), animated: true)
    }
    ///https://stackoverflow.com/questions/6150422/get-current-date-in-milliseconds
    func getDateStamp(for date: Date) -> TimeInterval{ //get seconds till current time selected
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)*60*60
        let minutes = calendar.component(.minute, from: date)*60
        let seconds = calendar.component(.second, from: date)
        print("Time now: \(hour+minutes+seconds)")
        return TimeInterval(hour+minutes+seconds)
    }
}

