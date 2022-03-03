//
//  MainViewController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
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
        
        configureNavigation()
        configureLayout()
    }
    
    // MARK: - configure
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(300)
        }
        
        view.addSubview(recordButton)
        recordButton.snp.makeConstraints {
            $0.bottom.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(100)
        }
        
    }
    
    // MARK: - Actions
    @objc func calendarButtonTapped() {
        print("달력 탭")
    }
    
    @objc func recordButtonTapped() {
        print(" 기록 ")
    }
}


