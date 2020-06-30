//
//  ProfileCallback.swift
//  Kader
//
//  Created by user165579 on 6/23/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation


protocol ProfileCallback {
    func onFinish(url: String)
    func onFinishWithIndexPath(url:String, index: IndexPath)
}
