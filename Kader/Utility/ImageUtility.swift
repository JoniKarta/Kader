//
//  ImageUtility.swift
//  Kader
//
//  Created by user165579 on 6/30/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation

import UIKit

class ImageUtility {
    
    static func circleImage(imageView: UIImageView){
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        //.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
    }
}
