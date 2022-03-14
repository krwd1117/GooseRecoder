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
    
    var todayDate = getDate(date: Date())
    var selectedDate = getDate(date: Date())
    
    lazy var tableView: UITableView = {
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
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "기록이 없어요"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    lazy var emptyNotiLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘이 아니면 기록을 남길 수 없어요"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MAINCOLOR
        
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        
        configureNavigation()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureLoadRecord()
        configureEmptyView()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cvc = segue.destination as? CalendarViewController else { return }
        cvc.delegate = self
    }
    
    // MARK: - Configure
    
    func configureEmptyView() {
        if RealmManager.shared.countRecords() > 0 {
            self.emptyView.isHidden = true
        } else {
            self.emptyView.isHidden = false
        }
    }
    
    func configureLoadRecord() {
        RealmManager.shared.loadRecords(selectedDate)
        
        print(RealmManager.shared.countRecords())
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
            action: #selector(trashButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func configureLayout() {
        let stack = UIStackView(arrangedSubviews: [tableView, emptyView, recordButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        emptyView.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
        
        emptyView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(emptyView)
        }
        
        emptyView.addSubview(emptyNotiLabel)
        emptyNotiLabel.snp.makeConstraints {
            $0.centerX.equalTo(emptyView)
            $0.top.equalTo(emptyLabel.snp.bottom).offset(16)
        }
        
        recordButton.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
    }
    
    // MARK: - Actions
    
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
    
    @objc func trashButtonTapped() {
        let alertController = UIAlertController(
            title: "삭제",
            message: "기록을 모두 지우시겠습니까?",
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let clear = UIAlertAction(title: "확인", style: .default) { [weak self] Action in
            self?.clearButtonTapped()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(clear)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // 휴지통
    @objc func clearButtonTapped() {
        RealmManager.shared.clearAllRecords(selectedDate)
        configureEmptyView()
        tableView.reloadData()
    }
    
    // 달력
    @objc func calendarButtonTapped() {
        let cvc = CalendarViewController()
        cvc.delegate = self
        present(cvc, animated: true, completion: nil)
    }
    
    // 기록 추가
    @objc func recordButtonTapped() {
        LocationManager.shared.getAddress { [weak self] address, latitude, longitude, error in
            guard let self = self else { return }
            
            if error == nil {
                RealmManager.shared.appendRecord(latitude: latitude, longitude: longitude, address: address)
                ProgressHUD.showSucceed()
                
                self.configureEmptyView()
                
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


