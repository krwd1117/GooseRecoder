//
//  DetailViewController+Extension.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/06.
//

import UIKit

extension DetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        confirmButtonTapped()
        textField.resignFirstResponder()
        return true
    }
    
}
