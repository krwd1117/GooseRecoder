//
//  DetailViewController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/05.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "돌산읍"
        return label
    }()
    
    lazy var timeLabel: UILabel = {
       let label = UILabel()
        label.text = "23:37:02"
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureLayout()
    }
    
    // MARK: - Configure
    
    private func configureLayout() {
        view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
        }
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.centerX.equalTo(addressLabel)
            $0.top.equalTo(addressLabel.snp.bottom).offset(16)
        }
    }
    
    // MARK: - Helpers
    
    
    
}
