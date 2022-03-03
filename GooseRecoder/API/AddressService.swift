//
//  AddressService.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import CoreLocation

struct AddressService {
    static func fetchAddress(lat: Double, lon: Double, completion: @escaping ([CLPlacemark]) -> Void ){
        let data = CLLocation(latitude: lat, longitude: lon)
        CLGeocoder().reverseGeocodeLocation(data, preferredLocale: Locale(identifier: "Ko-kr")) { place, error in
            if let address: [CLPlacemark] = place {
                completion(address)
            }
        }
    }
}


