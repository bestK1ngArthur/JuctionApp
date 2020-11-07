//
//  UIImageView+Utils.swift
//  JunctionApp
//
//  Created by admin on 07.11.2020.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadFromURL(photoUrl:String, complition: (()-> Void)? ) {
        //NSURL
        guard let url = URL(string: photoUrl) else { return }
        //Request
        let request = URLRequest(url:url);
        //Session
        let session = URLSession.shared
        //Data task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
                complition?()
            }
        }
        dataTask.resume()
    }
}
