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

        let recordItem = records[indexPath.row]
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
        
        present(dvc, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let uuidString = records[indexPath.row].uuidString
        
        do {
            try realm.write({
                let predicate = NSPredicate(format: "uuidString = %@", uuidString)
                realm.delete(realm.objects(Record.self).filter(predicate))
            })
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.height / 7
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if !records.isEmpty {
            count = records.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        cell.currentTime = records[indexPath.row].time
        cell.address = records[indexPath.row].address
        return cell
    }
}

// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
            locationManager.requestWhenInUseAuthorization()
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MainViewController: CalendarDelegate {
    func moveDate(date: String) {
        selectedDate = date

        let title = selectedDate.components(separatedBy: "-")
        navigationItem.title = "\(title[0])년 \(title[1])월 \(title[2])일"
        
        configureLoadRecord()
        
        if todayDate == selectedDate {
            recordButton.isHidden = false
        } else {
            recordButton.isHidden = true
        }
        
        tableView.reloadData()
    
    }
}