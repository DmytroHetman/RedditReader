//
//  CommentElement.swift
//  RedditComments
//
//  Created by Dmytro Hetman on 21.08.2022.
//

import Foundation

struct CommentElement: Codable {
    let data: CommentData
}

struct CommentData: Codable {
    let body: String?
    let created: Int?
    let username: String?
    let rating: Int?
    let permalink: String?
    let replies: CommentModel?
    let children: [String]?
    
    enum CodingKeys: String, CodingKey {
        case body
        case created
        case username = "author"
        case rating = "score"
        case permalink
        case replies
        case children
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.body = try? container.decodeIfPresent(String.self, forKey: .body)
        self.created = try? container.decodeIfPresent(Int.self, forKey: .created)
        self.username = try? container.decodeIfPresent(String.self, forKey: .username)
        self.rating = try? container.decodeIfPresent(Int.self, forKey: .rating)
        self.permalink = try? container.decodeIfPresent(String.self, forKey: .permalink)
        self.replies = try? container.decodeIfPresent(CommentModel.self, forKey: .replies)
        self.children = try? container.decodeIfPresent([String].self, forKey: .children)
    }
}
