//
//  SettingViewController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/09.
//

import UIKit
import SnapKit
import MessageUI

class SettingTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var list = ["문의 및 건의사항", "앱 평가"]
    
    lazy var versionTitle: UILabel = {
        let label = UILabel()
        label.text = "현재 버전 : \(VERSION)"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureNavigationBar()
        configureLayout()
    }
    
    
    // MARK: - Configure
    func configure() {
        tableView.backgroundColor = MAINCOLOR
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
    }
    
    func configureNavigationBar() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor : UIColor.white ]
    }
    
    func configureLayout() {
        view.addSubview(versionTitle)
        versionTitle.snp.makeConstraints {
            $0.bottom.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(
            title: "메일 전송 실패",
            message: "이메일 설정을 확인후, \n다시 시도해주세요.",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
