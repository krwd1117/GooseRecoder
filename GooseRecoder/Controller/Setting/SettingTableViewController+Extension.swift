//
//  SettingTableViewController+Extension.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/09.
//

import UIKit
import MessageUI

extension SettingTableViewController {
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch list[indexPath.row] {
        case "문의 및 건의사항" :
            if MFMailComposeViewController.canSendMail() {
                
                let compseVC = MFMailComposeViewController()
                compseVC.mailComposeDelegate = self
                
                compseVC.setToRecipients(["krwd1117@icloud.com"])
                compseVC.setSubject("<기로기> 문의 및 의견")
                compseVC.setMessageBody(
                    """
                    
                    문의 및 요청 사항을 입력해주세요.
                    
                    --------------------
                    APP Version : \(VERSION)
                    --------------------
                    """,
                    isHTML: false
                )
                
                self.present(compseVC, animated: true, completion: nil)
                
            }
            else {
                self.showSendMailErrorAlert()
            }
        case "앱 평가" :
            if let appstoreUrl = URL(string: "https://apps.apple.com/app/id1613037900") {
                var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
                urlComp?.queryItems = [
                    URLQueryItem(name: "action", value: "write-review")
                ]
                guard let reviewUrl = urlComp?.url else {
                    return
                }
                UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
            }
        default:
            return
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else { return UITableViewCell()}
        print(list[indexPath.row])
        cell.title = list[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension SettingTableViewController: MFMailComposeViewControllerDelegate {
    
}
