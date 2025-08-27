//
//  UIImageView+Extension.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImageWithSpinner(urlString: String, placeholder: UIImage? = nil) {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = CGPoint(x: bounds.midX, y: bounds.midY)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        addSubview(spinner)
        
        if let url = URL(string: urlString) {
            kf.setImage(
                with: url,
                placeholder: placeholder,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ],
                completionHandler: { [weak spinner] _ in
                    DispatchQueue.main.async {
                        spinner?.stopAnimating()
                        spinner?.removeFromSuperview()
                    }
                }
            )
        } else {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
}
