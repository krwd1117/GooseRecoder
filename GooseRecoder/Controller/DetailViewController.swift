//
//  DetailViewController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/05.
//

import UIKit
import SnapKit
import MapKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var recordItem: RecordItem? = nil
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
                let mark = Marker(
                    title: recordItem?.address,
                    subtitle: nil,
                    coordinate: CLLocationCoordinate2D(
                        latitude: recordItem?.latitude ?? 0.0,
                        longitude: recordItem?.longitude ?? 0.0
                    )
                )
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(
            latitude: recordItem?.latitude ?? 0.0,
            longitude: recordItem?.longitude ?? 0.0
        ), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        
                mapView.addAnnotation(mark)
        //        mapView.centerCoordinate = mark.coordinate
        mapView.scalesLargeContentImage = true
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        
        mapView.layer.borderColor = UIColor.label.cgColor
        mapView.layer.borderWidth = 1
        mapView.layer.cornerRadius = 20
        
        return mapView
    }()
    
    //    lazy var mark = Marker(
    //        title: recordItem?.address,
    //        subtitle: nil,
    //        coordinate: CLLocationCoordinate2D(latitude: recordItem?.latitude ?? 0.0, longitude: recordItem?.longitude ?? 0.0)
    //    )
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = recordItem?.address
        label.textColor = .systemBackground
        label.backgroundColor = .label
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = recordItem?.date
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = recordItem?.time
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        //        guard let mapView = mapView else { return }
        //        mapView.addAnnotation(mark)
        
        configureLayout()
    }
    
    // MARK: - Configure
    
    private func configureLayout() {
        view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.trailing.leading.equalToSuperview().inset(16)
        }
        
        let dateStack = UIStackView(arrangedSubviews: [dateLabel, timeLabel])
        dateStack.spacing = 32
        dateStack.distribution = .equalCentering
        
        view.addSubview(dateStack)
        dateStack.snp.makeConstraints {
            $0.centerX.equalTo(addressLabel)
            $0.top.equalTo(addressLabel.snp.bottom).offset(16)
        }
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            //            $0.top.equalTo(dateStack.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.leading.equalToSuperview().inset(16)
            $0.height.equalTo(mapView.snp.width)
        }
        
        //        view.addSubview(timeLabel)
        //        timeLabel.snp.makeConstraints {
        //            $0.centerX.equalTo(addressLabel)
        //            $0.top.equalTo(addressLabel.snp.bottom).offset(16)
        //        }
    }
    
    // MARK: - Helpers
    
    
    
}
