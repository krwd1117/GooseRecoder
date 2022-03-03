//
//  MainTableViewCell.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/03.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "하"
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configureLayout() {
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
        }
        
    }
}
