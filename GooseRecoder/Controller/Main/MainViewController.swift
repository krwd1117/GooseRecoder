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

import FSCalendar

class MainViewController: UIViewController {
    
    // MARK: - Properties
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation?
    var address: [CLPlacemark]?
    
    var records: Results<Record>!
    
    let realm = try! Realm()
    
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
        button.backgroundColor = RECORDCOLOR //FF5276
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        button.setTitle("기록", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MAINCOLOR
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        configure()
        
        configureNavigation()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureLoadRecord()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? CalendarViewController else { return }
        vc.delegate = self
    }
    
    // MARK: - Configure
    
    func configure() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
    }
    
    func configureLoadRecord() {
        let predicate = NSPredicate(format: "date = %@", selectedDate)
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
        
        let title = selectedDate.components(separatedBy: "-")
        navigationItem.title = "\(title[0])년 \(title[1])월 \(title[2])일"
        
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
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        recordButton.snp.makeConstraints {
            $0.height.equalTo(100)
        }
    }
    
    // MARK: - Actions
    
    // 휴지통 버튼 클릭
    @objc func clearButtonTapped() {
        do{
            try realm.write({
                let predicate = NSPredicate(format: "date = %@", selectedDate)
                realm.delete(realm.objects(Record.self).filter(predicate))
            })
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    // 달력 버튼 클릭
    @objc func calendarButtonTapped() {
        let cvc = CalendarViewController()
        cvc.delegate = self
        present(cvc, animated: true, completion: nil)
    }
    
    // 기록 버튼 클릭
    @objc func recordButtonTapped() {
        locationManager.requestWhenInUseAuthorization()
        addRecord()
    }
    
    // MARK: - Helpers
    
    private func addRecord() {
        guard let currentLocation = locationManager.location else { return }
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        AddressService.fetchAddress(lat: latitude, lon: longitude) { address in
            
            let recordItem = Record()
            recordItem.address = address
            recordItem.date = getDate(date: Date())
            recordItem.time = getTime(date: Date())
            recordItem.latitude = latitude
            recordItem.longitude = longitude
            
            try! self.realm.write {
                self.realm.add(recordItem)
            }
            
            self.tableView.reloadData()
            
            let endIndex = IndexPath(row: self.records.count-1, section: 0)
            self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)

        }
    }
}


