//
//  CalendarViewController+Extension.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/06.
//

import UIKit
import FSCalendar

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.delegate?.moveDate(date: getDate(date: date))
        dismiss(animated: true, completion: nil)
    }
}

extension CalendarViewController: FSCalendarDataSource {
    
}
