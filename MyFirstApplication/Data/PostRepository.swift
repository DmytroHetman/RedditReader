//
//  PostRepository.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 13.05.2022.
//

import Foundation

class PostRepository {
    // MARK: 
    static let shared = PostRepository()
    var savedPosts: [Post] = []
    var isSearching = false
    
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
            self.savedPosts = postData
        } catch {
            print(error)
        }
        
    }
    
    
    
    // MARK: - Saving
    func saveUnsavePost(post: Post) {
        if let postIndex = ActiveSessionPosts.shared.posts.firstIndex(where: { $0.id == post.id }) {
            ActiveSessionPosts.shared.posts[postIndex].saved.toggle()
        }
        if post.saved {
            if let postIndex = self.savedPosts.firstIndex(where: {$0 == post}){
                self.savedPosts.remove(at: postIndex)
            }
        } else {
            self.savedPosts.append(post)
            self.savedPosts[self.savedPosts.count-1].saved.toggle()
        }
    }
    
    
    
}
