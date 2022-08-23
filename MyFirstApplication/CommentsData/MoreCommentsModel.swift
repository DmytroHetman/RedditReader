//
//  MoreCommentsModel.swift
//  RedditComments
//
//  Created by Dmytro Hetman on 21.08.2022.
//

import Foundation

struct MoreCommentsModel: Codable {
    
    let json: MoreCommentsData
    
}

struct MoreCommentsData: Codable {
    
    let data: MoreCommentsThings
    
}

struct MoreCommentsThings: Codable {
    
    let things: [CommentElement]
    
}
