//
//  Post.swift
//  Babylon iOS Interview Demo
//
//  Created by João Pereira on 24/01/2019.
//  Copyright © 2019 NSMyself. All rights reserved.
//

import Foundation

public struct Post: Codable, Hashable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}