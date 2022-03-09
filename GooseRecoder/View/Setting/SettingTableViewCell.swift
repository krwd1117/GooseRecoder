//
//  SettingTableViewCell.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/09.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var title: String? {
        didSet {
            configure()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        configure()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure() {
        titleLabel.text = title
        backgroundColor = MAINCOLOR
    }
    
    func configureLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
    }
    
    
}
