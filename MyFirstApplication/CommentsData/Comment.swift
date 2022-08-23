//
//  Comment.swift
//  RedditComments
//
//  Created by Dmytro Hetman on 15.08.2022.
//

import Foundation

struct Comment: Identifiable, Hashable {
    
    var id = UUID()
    
    let username: String
    let created: String
    let body: String
    let rating: Int
    let permalink: String
    let replies: [Comment]?
    
    init(username: String, created: String, body: String, rating: Int, permalink: String, replies: CommentModel?) {
        self.username = username
        self.created = created
        self.body = body
        self.rating = rating
        self.permalink = permalink
        self.replies = replies?.data?.children?.compactMap { comment -> Comment? in
            
            guard let username = comment.data.username else { return nil }
            let calendar = Calendar.current
            guard let created = comment.data.created else { return nil }
            let hoursAgo = calendar.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(created)))
            guard let body = comment.data.body else { return nil }
            guard let rating = comment.data.rating else { return nil }
            
            return Comment(
                username: "u/\(username)",
                created: "\(hoursAgo)h",
                body: body,
                rating: rating,
                permalink: permalink,
                replies: comment.data.replies != nil ? comment.data.replies : nil
            )
        }
    }
    
}


