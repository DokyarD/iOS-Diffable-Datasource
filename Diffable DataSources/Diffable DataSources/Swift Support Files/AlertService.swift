//
//  AlertServices.swift
//  Diffable DataSources
//
//  Created by Meet Soni on 28/02/20.
//  Copyright © 2020 Meet Soni. All rights reserved.
//

import UIKit

struct AlertService {
    
    func createUserAlert(completion: @escaping (String) -> Void) -> UIAlertController {
        let attributedString = NSAttributedString(string: "Add Country", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        ])
        let alert = UIAlertController(title: "Add Country", message: nil, preferredStyle: .alert)
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addTextField { $0.placeholder = "Enter Country Name" }
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            let usersName = alert.textFields?.first?.text ?? ""
            completion(usersName)
        }
        alert.addAction(action)
        return alert
    }
}
