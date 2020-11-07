//
//  UIView+Utils.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import UIKit

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    func animateHidden(_ isHidden: Bool, with duration: TimeInterval = 0.3, options: AnimationOptions = []) {
        
        if isHidden {
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.isHidden = true
            })
        } else {
            self.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        }
    }
}


