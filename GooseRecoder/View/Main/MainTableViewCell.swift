//
//  MainTableViewCell.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import SnapKit
import CoreLocation

class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var time: Date? {
        didSet {
            configure()
        }
    }
    
    var currentTime: String? {
        didSet {
            configure()
        }
    }
    
    var address: String? {
        didSet{
            configure()
        }
    }
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "위치"
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure() {
        backgroundColor = .white
        
        guard let currentTime = currentTime else { return }
        timeLabel.text = currentTime

        guard let address = address else { return }
        addressLabel.text = address
        
    }
    
    func configureLayout() {
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(100)
            
        addSubview(addressLabel)
            addressLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(timeLabel.snp.trailing).offset(10)
                $0.trailing.equalToSuperview().inset(10)
            }
        }
    }
}
