//
//  Posts.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 13.05.2022.
//

import Foundation

class ActiveSessionPosts {
    static let shared = ActiveSessionPosts()
    var posts: [Post] = []

    private init() { }
}
