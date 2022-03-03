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

}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
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
