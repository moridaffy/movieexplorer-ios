//
//  UIViewController+Alert.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, body: String?, button: String?, actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        for action in actions ?? [] {
            alert.addAction(action)
        }
        
        if let button = button {
            let cancel = UIAlertAction(title: button, style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancel)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertError(error: Error?, desc: String?, critical: Bool) {
        var body: String = desc ?? NSLocalizedString("Unknown error occured", comment: "")
        if let error = error {
            body += "\n" + NSLocalizedString("Error description", comment: "") + ": \(error.localizedDescription)"
        }
        var button: String? {
            if critical {
                return nil
            } else {
                return NSLocalizedString("Ok", comment: "")
            }
        }
        
        showAlert(title: NSLocalizedString("Error", comment: ""), body: body, button: button, actions: nil)
    }
    
}

