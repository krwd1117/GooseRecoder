//
//  AddressService.swift
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
                guard let location = address.first else { return }
                guard let addressStr = location.name else { return }
            
                completion(addressStr)
            }
        }
    }
}





