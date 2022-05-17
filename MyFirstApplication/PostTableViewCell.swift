//
//  PostTableViewCell.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 04.05.2022.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var postView: PostView!
    
    // MARK: - Properties
    
    weak var delegate: PostTableViewCellDelegate? { didSet { self.postView.delegate = self.delegate } }
    
    // MARK: Config
    
    func config(from postData: Post) {
        self.postView.post = postData
        self.postView.username.text = postData.username
        self.postView.timePassed.text = postData.timePassed
        self.postView.domain.text = postData.domain
        self.postView.postTitle.text = postData.title
        self.postView.ratingButton.setTitle(postData.rating, for: .normal)
        self.postView.numCommentsButton.setTitle(postData.numComments, for: .normal)
        
        if let postImageURL = postData.image {
            let image = URL(string: postImageURL)
            let placeholder = UIImage(named: "photo")
            self.postView.postImage.sd_setImage(with: image, placeholderImage: placeholder)
        } else {
            self.postView.postImage.image = UIImage(named: "photo")
        }
        
        if !postData.saved {
            self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        } else {
            self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    
    }

}


