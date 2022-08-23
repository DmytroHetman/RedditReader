//
//  CommentRepository.swift
//  RedditComments
//
//  Created by Dmytro Hetman on 15.08.2022.
//

import Foundation
final class CommentRepository: ObservableObject {
    @Published var comments: [Comment] = []
    var moreCommentsArr: [String] = []
    var counter = 0
    var loadingMoreComments = false
    
    private let subreddit: String
    private let limit: Int
    private let depth: Int
    let postID: String
    
    init(subreddit: String, limit: Int, depth: Int, postID: String) async {
        self.subreddit = subreddit
        self.limit = limit
        self.depth = depth
        self.postID = postID
        Task {
            await fetchData()
        }
        
    }
    
    func fetchData() async {
        
        guard let url = URL(string: "https://www.reddit.com/r/\(self.subreddit)/comments/\(self.postID).json?limit=\(self.limit)&depth=\(self.depth)") else { fatalError() }
        var wrappedComments: [CommentModel] = []
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let commentsData = try JSONDecoder().decode([CommentModel].self, from: data)
            wrappedComments = commentsData
            guard let more = wrappedComments.last?.data?.children?.last?.data.children else { return }
            self.moreCommentsArr = more
        } catch {
            print(error)
        }
        let comments = unwrappedComments(commentModel: wrappedComments)
        DispatchQueue.main.async {
            self.comments.append(contentsOf: comments)
        }
        
    }
    
    public func loadMoreComments(linkID: String) async {
        if !self.loadingMoreComments {
            self.loadingMoreComments = true
            await fetchMoreComments(linkID: linkID, limit: Const.limit, depth: Const.depth)
        }
    }
    
    func fetchMoreComments(linkID: String = "t3_wli6ud", limit: Int, depth: Int) async {
        
    
        let range = 0..<min(counter+limit, self.moreCommentsArr.count)
        let children = self.moreCommentsArr[range].joined(separator: ",")
        self.moreCommentsArr.removeSubrange(range)
        counter+=limit
        
        guard let url = URL(string: "https://www.reddit.com/api/morechildren.json?limit=\(limit)&depth=\(depth)&link_id=t3_\(linkID)&api_type=json&children=\(children)") else { return }
        var wrappedMoreComments: [CommentElement] = []
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let commentsData = try JSONDecoder().decode(MoreCommentsModel.self, from: data)
            wrappedMoreComments = commentsData.json.data.things
            
        } catch {
            print(error)
        }
        let moreComments = unwrappedMoreComments(moreComments: wrappedMoreComments)
        DispatchQueue.main.async {
            self.comments.append(contentsOf: moreComments)
        }
        
        self.loadingMoreComments = false
//        return moreComments
    }
    
    func unwrappedComments(commentModel: [CommentModel]) -> [Comment] {
        guard let childrenComments = commentModel.last?.data?.children else { return [] }
        let comments: [Comment] = childrenComments.compactMap { wrappedComment -> Comment? in
            guard let body = wrappedComment.data.body else { return nil }
            guard let username = wrappedComment.data.username else { return nil }

            let calendar = Calendar.current
            guard let created = wrappedComment.data.created else { return nil }
            let hoursAgo = calendar.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(created)))

            guard let rating = wrappedComment.data.rating else { return nil }
            guard let permalink = wrappedComment.data.permalink else { return nil }
            
            guard let replies = wrappedComment.data.replies else { return nil }
            
            let comment = Comment(
                username: "u/\(username)",
                created: "\(hoursAgo)h",
                body: body,
                rating: rating,
                permalink: permalink,
                replies: replies
            )
            return comment
        }
        return comments
    }
    
    func unwrappedMoreComments(moreComments: [CommentElement]) -> [Comment] {
        let more = moreComments.compactMap { wrappedCommentElement -> Comment? in
            guard let body = wrappedCommentElement.data.body else { return nil }
            guard let username = wrappedCommentElement.data.username else { return nil }
                    
            let calendar = Calendar.current
            guard let created = wrappedCommentElement.data.created else { return nil }
            let hoursAgo = calendar.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(created)))
            
            guard let rating = wrappedCommentElement.data.rating else { return nil }
            guard let permalink = wrappedCommentElement.data.permalink else { return nil }
            
            let comment = Comment(
                username: "u/\(username)",
                created: "\(hoursAgo)h",
                body: body,
                rating: rating,
                permalink: permalink,
                replies: wrappedCommentElement.data.replies ?? nil
            )
            return comment
        }
        return more
    }
    
    
}
