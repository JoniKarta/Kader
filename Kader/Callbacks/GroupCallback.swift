//
//  GroupCallback.swift
//  Kader
//
//  Created by user165579 on 6/22/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation

protocol GroupCallback {
    func onFinish(user: User, group: [Group])
}
