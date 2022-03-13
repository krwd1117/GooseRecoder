//
//  File.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/13.
//

import UIKit
import CoreLocation

enum LocationError: Error {
    case PermissionError
    case NetworkError
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        requestLocationAccess()
    }
    
    func requestLocationAccess() {
        if locationManager == nil {
            print("DEBUG: 위치 권한 매니저")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        } else {
            print("ERROR: 위치 권한 매니저 오류")
        }
    }
    
    // 위치 추적 시작
    func startUpdating() {
        locationManager?.startUpdatingLocation()
    }
    
    // 위치 추적 종료
    func stopUpdating() {
        if locationManager != nil {
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func getAddress(completion: @escaping (String, CLLocationDegrees, CLLocationDegrees, Error?) -> Void){

        guard let currentLocation = locationManager?.location else {
            return completion("", 0.0, 0.0, LocationError.PermissionError)
        }
    
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        
        CLGeocoder().reverseGeocodeLocation(
            CLLocation(latitude: latitude, longitude: longitude),
            preferredLocale: Locale(identifier: "ko_kr")) { place, error in
                
                guard let address = place else { return
                    completion(" ", latitude, longitude, LocationError.NetworkError)
                }
                
                var customAddress = ""
                if address.last?.subThoroughfare == nil {
                    customAddress = "\(address.last?.locality ?? "") \(address.last?.thoroughfare ?? "")"
                } else {
                    customAddress = "\(address.last?.thoroughfare ?? "") \(address.last?.subThoroughfare ?? "")"
                }
                completion(customAddress, latitude, longitude, error)
            }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager?.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            self.locationManager?.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
            self.locationManager?.requestWhenInUseAuthorization()
        default:
            print("GPS: Default")
        }
    }
    
    // 실패 했을경우 받은 알림
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: 위치 정보를 가져오는데 실패했습니다.")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }
}


