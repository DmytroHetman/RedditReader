//
//  Request.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 21.02.2022.
//

import Foundation

class Request {
    
    static let shared = Request()
    
    private init() { }
    
    func fetchData(subreddit: String, limit: Int, after: String, fetch: @escaping ([Post]) -> Void) {
        let urlSession = URLSession(configuration: .default)
        guard let urlString = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json?limit=\(limit)&after=\(after)")
        else { return }
        
        urlSession.dataTask(with: urlString) { data,response,error in
            guard let data = data,
                  let postData = try? JSONDecoder().decode(Model.self, from: data)
            else { return }
            
            let posts = postData.data.children.compactMap {
                child -> Post? in
                
                if PostRepository.shared.savedPosts.contains(where: { $0.id == child.data.id }) {
                    return PostRepository.shared.savedPosts.first(where: { $0.id == child.data.id })
                } else {
                    let calendar = Calendar.current
                    var postImageURL: String?
                    if let imageURL = child.data.preview?.images.first?.source.url {
                        postImageURL = imageURL.replacingOccurrences(of: "amp;", with: "")
                    }
                    let post = Post(
                        username: "u/\(child.data.author) · ",
                        timePassed: "\(calendar.component(.hour, from: Date(timeIntervalSince1970: child.data.created )))h · ",
                        domain: child.data.domain,
                        title: child.data.title,
                        image: postImageURL,
                        rating: "\(child.data.rating)",
                        numComments: "\(child.data.numComments)",
                        after: "\(child.data.name)",
                        url: "https://www.reddit.com\(child.data.permalink)",
                        saved: child.data.saved,
                        id: "\(child.data.id)"
                    )
                    return post
                }
                
            }
            fetch(posts)
        }.resume()
    }
    
}
