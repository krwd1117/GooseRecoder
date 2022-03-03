//
//  MainViewController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import CoreLocation
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation?
    var address: [CLPlacemark]?
    var addressStr = ""
    
    var records: [Record] = []
    
    lazy var tableView : UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .white
        tb.layer.cornerRadius = 20
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(rgb: 0xFE8D90) //FF5276
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        button.setTitle("기록", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb:0x1c252e)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        configure()
        configureNavigation()
        configureLayout()
    }
    
    // MARK: - Configure
    
    func configure() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
    }
    
    func configureNavigation() {
        // 왼쪽 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "calendar"),
            style: .plain,
            target: self,
            action: #selector(calendarButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        // 타이틀
        navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor : UIColor.white ]
        navigationItem.title = "03월 03일"
    }
    
    func configureLayout() {
        
        let stack = UIStackView(arrangedSubviews: [tableView, recordButton])
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        recordButton.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
    }
    
    // MARK: - Actions
    @objc func calendarButtonTapped() {
        print("달력 탭")
    }
    
    @objc func recordButtonTapped() {
        locationManager.requestWhenInUseAuthorization()
        getAddress()
    }
    
    // MARK: - Helpers
    func getAddress() {
        guard let currentLocation = locationManager.location else { return }
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        AddressService.fetchAddress(lat: latitude, lon: longitude) { address in
            self.address = address
            
            let locality = address.last?.locality ?? ""
            let subLocality = address.last?.subLocality ?? ""
            let thoroughfare = address.last?.thoroughfare ?? ""
            let subThoroughfare = address.last?.subThoroughfare ?? ""
            self.addressStr = "\(locality) \(subLocality) \(thoroughfare) \(subThoroughfare)"
            
            self.records.append(Record(address: self.addressStr))
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            //            print(address.last?.locality) // 여수시
            //            print(address.last?.subLocality) // 돌산읍
            //            print(address.last?.thoroughfare) // 강남해안로
            //            print(address.last?.subThoroughfare) // 74
        }
    }
}


