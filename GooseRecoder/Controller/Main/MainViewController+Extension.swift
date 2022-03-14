//
//  MainViewController+Extension.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import CoreLocation

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let recordItem = RealmManager.shared.records[indexPath.row]
        let dvc = DetailViewController()
        dvc.recordItem = RecordItem(
            uuidString: recordItem.uuidString,
            date: recordItem.date,
            time: recordItem.time,
            address: recordItem.address,
            latitude: recordItem.latitude,
            longitude: recordItem.longitude,
            memo: recordItem.memo
        )

        navigationController?.pushViewController(dvc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let uuidString = RealmManager.shared.records[indexPath.row].uuidString
        RealmManager.shared.deleteRecord(uuidString: uuidString)
        configureEmptyView()
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.height / 7
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmManager.shared.countRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        
        let item = RealmManager.shared.records[indexPath.row]
        
        cell.recordItem = RecordItem(
            uuidString: item.uuidString,
            date: item.date,
            time: item.time,
            address: item.address,
            latitude: item.latitude,
            longitude: item.longitude,
            memo: item.memo
        )
        return cell
    }
}

// MARK: - CalendarDelegate
extension MainViewController: CalendarDelegate {
    func changeCalendarDate(date: String) {
        print("changeCalendarDate")
        selectedDate = date
        let title = selectedDate.components(separatedBy: "-")
        navigationItem.title = "\(title[0])년 \(title[1])월 \(title[2])일"
        configureLoadRecord()
        
        if todayDate == selectedDate {
            recordButton.isHidden = false
            emptyNotiLabel.isHidden = true
        } else {
            recordButton.isHidden = true
            emptyNotiLabel.isHidden = false
        }
        
        configureEmptyView()    
        
        tableView.reloadData()
    }
}
