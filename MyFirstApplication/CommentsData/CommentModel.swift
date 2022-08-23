//
//  Comment.swift
//  RedditComments
//
//  Created by Dmytro Hetman on 10.08.2022.
//

import Foundation

struct CommentModel: Codable {
    let data: ChildrenData?
}

struct ChildrenData: Codable {
    let children: [CommentElement]?
}






