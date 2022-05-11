//
//  PostViewController.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 20.02.2022.
//

import UIKit
import SDWebImage

class PostDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var postView: PostView!
    
    // MARK: - Properties
    var post: Post?
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            guard let post = self.post else { return }
            self.postView.username.text = post.username
            self.postView.timePassed.text = post.timePassed
            self.postView.domain.text = post.domain
            self.postView.postTitle.text = post.postTitle
            self.postView.ratingButton.setTitle(post.rating, for: .normal)
            self.postView.numCommentsButton.setTitle(post.numComments, for: .normal)

            // Image of post
            if let postImageURL = post.postImage {
                let image = URL(string: postImageURL)
                self.postView.postImage.sd_setImage(with: image, placeholderImage: UIImage(named: "photo"))
            } else {
                self.postView.postImage.image = UIImage(named: "photo")
            }
            
            // Bookmark button
            let state = Int.random(in: 0...1)
            let bookmark = UIImage(systemName: "bookmark")
            let bookmarkFill = UIImage(systemName: "bookmark.fill")
            self.postView.bookmarkButton.imageView?.image = state == 0 ? bookmark : bookmarkFill
        }
    }

}
