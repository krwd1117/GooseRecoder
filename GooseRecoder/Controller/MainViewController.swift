//
//  MainViewController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import CoreLocation
import SnapKit

import RealmSwift
import SwiftUI

class MainViewController: UIViewController {
    
    // MARK: - Properties
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation?
    var address: [CLPlacemark]?
    
    var records: Results<Record>!
    
    let realm = try! Realm()
    
    var addressStr = ""
    var timeStr = ""
    var dateStr = ""
    var latitude = 0.0
    var longitude = 0.0
    
    var todayDate = getDate(date: Date())
    var selectedDate = getDate(date: Date())
    
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
        configureLoadRecord()
        configureNavigation()
        configureLayout()
    }
    
    // MARK: - Configure
    
    func configure() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        dateStr = getDate(date: Date())
    }
    
    func configureLoadRecord() {
        let predicate = NSPredicate(format: "date = %@", dateStr)
        records = realm.objects(Record.self).filter(predicate).sorted(byKeyPath: "time", ascending: true)
    }
    
    func configureLoadTest() {
        let predicate = NSPredicate(format: "date = '2022-03-05'", dateStr)
        records = realm.objects(Record.self).filter(predicate).sorted(byKeyPath: "time", ascending: true)
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
        navigationItem.title = getDate(date: Date())
        
        // 오른쪽 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "trash.circle"),
            style: .plain,
            target: self,
            action: #selector(clearButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .white
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
    @objc func clearButtonTapped() {
        do{
            try realm.write({
                let predicate = NSPredicate(format: "date = %@", getDate(date: Date()))
                realm.delete(realm.objects(Record.self).filter(predicate))
            })
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    @objc func calendarButtonTapped() {
        print("달력 탭")
        //        configureLoadTest()
        selectedDate = ""
        
        DispatchQueue.main.async {
            if self.todayDate == self.selectedDate {
                UIView.transition(with: self.recordButton, duration: 0.4,
                                  options: .autoreverse,
                                  animations: {
                    self.recordButton.isHidden = false
                })
            } else {
                UIView.transition(with: self.recordButton, duration: 0.4,
                                  options: .transitionFlipFromBottom,
                                  animations: {
                    self.recordButton.isHidden = true
                })
            }
        }
        
        tableView.reloadData()
        print(records)
    }
    
    @objc func recordButtonTapped() {
        locationManager.requestWhenInUseAuthorization()
        getAddress()
    }
    
    // MARK: - Helpers
    
    private func getAddress() {
        guard let currentLocation = locationManager.location else { return }
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        AddressService.fetchAddress(lat: latitude, lon: longitude) { address in
            self.addRecord(address)
        }
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private func addRecord(_ address: String) {
        let address = address
        let time = getTime(date: Date())
        let date = getDate(date: Date())
        
        let recordItem = Record()
        recordItem.address = address
        recordItem.date = date
        recordItem.time = time
        
        try! realm.write {
            realm.add(recordItem)
        }
        
        tableView.reloadData()
        
        let endIndex = IndexPath(row: records.count-1, section: 0)
        tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
    }
    
}


