//
//  NamePopupController.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import UIKit

class NamePopupController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let name = nameField.text, !name.isEmpty else { return }
        
        Storage.current.userName = name
        
        if let roomController = presentingViewController as? RoomController {
            roomController.showIntroduction()
        }
        
        dismiss(animated: false, completion: nil)
    }
}

extension NamePopupController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
