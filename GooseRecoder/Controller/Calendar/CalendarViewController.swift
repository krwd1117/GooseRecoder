//
//  CalendarViewController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/06.
//

import UIKit
import SnapKit
import FSCalendar

protocol CalendarDelegate: AnyObject {
    func changeCalendarDate(date: String)
}

class CalendarViewController: UIViewController {
    // MARK: - Properties
    
    weak var delegate: CalendarDelegate?
    
    var calendarView: FSCalendar = {
        let cv = FSCalendar()
        cv.backgroundColor = MAINCOLOR
        cv.appearance.titleDefaultColor = .white
        cv.appearance.titleWeekendColor = .red
        cv.appearance.selectionColor = RECORDCOLOR
        cv.appearance.headerTitleColor = RECORDCOLOR
        cv.appearance.weekdayTextColor = RECORDCOLOR
        cv.locale = Locale(identifier: "ko_kr")
        cv.appearance.headerDateFormat = "YYYY년 M월"
        cv.appearance.todayColor = UIColor(red: 188/255, green: 224/255, blue: 253/255, alpha: 1)
        return cv
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    // MARK: - ConfigureLayout
    func configureLayout() {
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Helpers
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.delegate?.changeCalendarDate(date: getDate(date: date))
        dismiss(animated: true, completion: nil)
    }
}

extension CalendarViewController: FSCalendarDataSource {
    
}
