//
//  NamePopupController.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import UIKit

class NamePopupController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var buttonCardConstraint: NSLayoutConstraint!

    @IBOutlet weak var buttonCard: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let name = nameField.text, !name.isEmpty else { return }
        
        Storage.current.userName = name
        
        if let roomController = presentingViewController as? RoomController {
            roomController.showIntroduction()
            roomController.checkStartupState()
        }
        
        UIView.animate(withDuration: 0.1) {
            self.cardView.alpha = 0.0
        } completion: { (_) in
            UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: []) {
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                        self.buttonCardConstraint.constant = 132
                }
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                        self.heightConstraint.constant = self.view.bounds.height
                }

                self.view.layoutIfNeeded()
            } completion: { (_) in
                UIView.animate(withDuration: 0.2) {
                    self.view.alpha = 0.0
                } completion: { (_) in
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
}

extension NamePopupController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
