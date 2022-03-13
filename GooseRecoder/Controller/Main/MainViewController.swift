//
//  MainViewController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import SnapKit

import SwiftUI
import FSCalendar

import ProgressHUD

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
//        var records: Results<Record>!
    
    //    let realm = try! Realm()
    
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
        
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        
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
        
    }
    
    func configureLoadRecord() {
        RealmManager.shared.loadRecords(selectedDate)
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
    
    func alertFuntion(errorTitle: String, errorMessage: String) {
        let alertController = UIAlertController(
            title: errorTitle,
            message: errorTitle,
            preferredStyle: .alert
        )
        let done = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(done)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    // 휴지통
    @objc func clearButtonTapped() {
        RealmManager.shared.clearAllRecords(selectedDate)
        tableView.reloadData()
    }
    
    // 달력
    @objc func calendarButtonTapped() {
        let cvc = CalendarViewController()
        cvc.delegate = self
        present(cvc, animated: true, completion: nil)
    }
    
    // 기록
    @objc func recordButtonTapped() {
        LocationManager.shared.getAddress { [weak self] address, latitude, longitude, error in
            guard let self = self else { return }
            
            if error == nil {
                RealmManager.shared.appendRecord(latitude: latitude, longitude: longitude, address: address)
                ProgressHUD.showSucceed()
                
                self.tableView.reloadData()
                let endIndex = IndexPath(row: RealmManager.shared.countRecords()-1, section: 0)
                self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
            } else if error != nil {
                guard let error = error else { return }
                if error as! LocationError == LocationError.NetworkError {
                    self.alertFuntion(
                        errorTitle: "위치 정보를 가져올 수 없습니다.",
                        errorMessage: "네트워크 연결을 확인해주세요."
                    )
                } else if error as! LocationError == LocationError.PermissionError {
                    self.alertFuntion(
                        errorTitle: "위치 권한을 확인할 수 없습니다.",
                        errorMessage: "위치 권한을 '허용'해야 기록을 남길 수 있어요."
                    )
                }
                else {
                    self.alertFuntion(
                        errorTitle: "Error Message",
                        errorMessage: "\(error.localizedDescription)"
                    )
                }
            }
        }
    }
}


