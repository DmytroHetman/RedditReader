//
//  PostViewController.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 20.02.2022.
//

import UIKit
import SDWebImage

class PostViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var timePassed: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var ratingButton: UIButton!
    @IBOutlet private weak var numCommentsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.overrideUserInterfaceStyle = .dark
        let subreddit = "apple"
        let limit = 1
        
        
        guard let urlString = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json?limit=\(limit)")
        else { return }
        
        let urlSession = URLSession(configuration: .default)
        
        
        urlSession.dataTask(with: urlString) { data,response,error in
            guard let data = data,
                  let postData = try? JSONDecoder().decode(Model.self, from: data)
            else { return }
            
            DispatchQueue.main.async {
                
                // Post data
                let calendar = Calendar.current
                let timePassed = calendar.component(.hour, from: Date(timeIntervalSince1970: postData.data.children.first?.data.created ?? -1.0 ))
                self.username.text = "u/\(postData.data.children.first?.data.author ?? "") · "
                self.timePassed.text = "\(timePassed)h · "
                self.domain.text = postData.data.children.first?.data.domain ?? ""
                self.postTitle.text = postData.data.children.first?.data.title ?? ""
                self.ratingButton.setTitle("\(postData.data.children.first?.data.rating ?? -1)", for: .normal)
                self.numCommentsButton.setTitle("\(postData.data.children.first?.data.numComments ?? -1)", for: .normal)
                
                // Image of post
                if let imageURL = postData.data.children.first?.data.preview?.images.first?.source.url {
                    let formattedURL = imageURL.replacingOccurrences(of: "amp;", with: "")
                    let image = URL(string: formattedURL)
                    self.imageView.sd_setImage(with: image)
                } else {
                    self.imageView.image = UIImage(named: "photo")
                }
                
                // Bookmark button
                let state = Int.random(in: 0...1)
                let bookmark = UIImage(systemName: "bookmark")
                let bookmarkFill = UIImage(systemName: "bookmark.fill")
                self.bookmarkButton.imageView?.image = state == 0 ? bookmark : bookmarkFill
                
            }
            
        }.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
