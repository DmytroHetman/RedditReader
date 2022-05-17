//
//  PostRepository.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 13.05.2022.
//

import Foundation

class PostRepository {
    
    static let shared = PostRepository()
    var savedPosts: [Post] = []
    
    
    private init() { }
    
    
    // MARK: - Work with files
    func writeToFile(_ posts: [Post]) {
        self.savedPosts = posts.filter { $0.saved }
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileName = "savedPosts.json"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            guard let jsonData = try? JSONEncoder().encode(self.savedPosts) else { return }
            let savedPostsString = String(decoding: jsonData, as: UTF8.self)
            guard let content = savedPostsString.data(using: .utf8) else { return }
            try content.write(to: fileURL, options: .atomic)
        } catch {
            print(error)
        }
    }
    
    func readFile() {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileName = "savedPosts.json"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            let jsonString = try String(contentsOf: fileURL)
            let savedPostsJson = Data(jsonString.utf8)
            guard let postData = try? JSONDecoder().decode([Post].self, from: savedPostsJson) else { return }
            print(fileURL)
            self.savedPosts = postData
        } catch {
            print(error)
        }
        
    }
    
    
    // MARK: - Lifecycle
    
    func loadsPosts(after: String) {
        Request.shared.fetchData(
            subreddit: Constants.subreddit,
            limit: Constants.limit,
            after: after) { postsData in
                ActiveSessionPosts.shared.posts.append(contentsOf: postsData)
            }
    }
    
    func updateUIData(savedPostsShown: Bool) -> [Post] {
        return savedPostsShown ? PostRepository.shared.savedPosts : ActiveSessionPosts.shared.posts
    }
    
    func saveUnsaveToggle(post: Post) {
        if let numOfPost = ActiveSessionPosts.shared.posts.firstIndex(where: {post.id == $0.id }) {
            ActiveSessionPosts.shared.posts[numOfPost].saved.toggle()
        }
        if let numOfPost = PostRepository.shared.savedPosts.firstIndex(where: {post.id == $0.id }) {
            PostRepository.shared.savedPosts[numOfPost].saved.toggle()
        }
    }
    
    func saveUnsavePost(post: Post) {
        guard let index = ActiveSessionPosts.shared.posts.firstIndex(of: post) else { return }
        print("before append \(self.savedPosts)")
        if post.saved {
            if !self.savedPosts.contains(post) {
                self.savedPosts.append(post)
                print("after append \(self.savedPosts)")
            }
            ActiveSessionPosts.shared.posts[index].saved = true
        } else {
            if let index = self.savedPosts.firstIndex(of: post){
                self.savedPosts.remove(at: index)
            }
            ActiveSessionPosts.shared.posts[index].saved = false
        }
        
    }
    
    
    
}
