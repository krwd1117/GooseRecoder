//
//  AddressService.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import CoreLocation

struct AddressService {
    static func fetchAddress(lat: Double, lon: Double, completion: @escaping (String) -> Void ){
        let data = CLLocation(latitude: lat, longitude: lon)
        CLGeocoder().reverseGeocodeLocation(
            data,
            preferredLocale: Locale(identifier: "Ko-kr")
        ) { place, error in
            if let address: [CLPlacemark] = place {
                let locality = address.last?.locality ?? "" // 여수시
                let subLocality = address.last?.subLocality ?? "" // 돌산읍
                let thoroughfare = address.last?.thoroughfare ?? "" // 강남해안로
                let subThoroughfare = address.last?.subThoroughfare ?? "" // 74
                let addressStr = "\(locality) \(subLocality) \(thoroughfare) \(subThoroughfare)"
                completion(addressStr)
            }
        }
    }
}





