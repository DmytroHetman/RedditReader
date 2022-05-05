//
//  Request.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 21.02.2022.
//

import Foundation

class Request {
    
    var username: String = "none"
    var timePassed: String = "-h"
    var domain: String = "/none"
    var postTitle: String = "none"
    var postImageURL: String? = nil
    var rating: String = "-1"
    var comments: String = "-1"
    
    func getPostData(subreddit: String, limit: Int, after: String, fetch: @escaping (Request) -> Void) {
        
        guard let urlString = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json?limit=\(limit)&after=\(after)")
        else { return }
        
        let urlSession = URLSession(configuration: .default)
        
        urlSession.dataTask(with: urlString) { data,response,error in
            guard let data = data,
                  let postData = try? JSONDecoder().decode(Model.self, from: data)
            else { return }
            
            self.username = "u/\(postData.data.children.first?.data.author ?? "") · "
            let calendar = Calendar.current
            self.timePassed = "\(calendar.component(.hour, from: Date(timeIntervalSince1970: postData.data.children.first?.data.created ?? -1)))h · "
            self.domain = postData.data.children.first?.data.domain ?? ""
            self.postTitle = postData.data.children.first?.data.title ?? ""
            self.rating = "\(postData.data.children.first?.data.rating ?? -1)"
            self.comments = "\(postData.data.children.first?.data.numComments ?? -1)"
            if let imageURL = postData.data.children.first?.data.preview?.images.first?.source.url {
                self.postImageURL = imageURL.replacingOccurrences(of: "amp;", with: "")
            }
            fetch(self)
        }.resume()
    }
    
    
    
    
    
    
}
