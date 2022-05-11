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
    
    // MARK: Config
    
    func config(from postData: Post) {
        self.postView.username.text = postData.username
        self.postView.timePassed.text = postData.timePassed
        self.postView.domain.text = postData.domain
        self.postView.postTitle.text = postData.postTitle
        self.postView.ratingButton.setTitle(postData.rating, for: .normal)
        self.postView.numCommentsButton.setTitle(postData.numComments, for: .normal)
        
        // Image of post
        if let postImageURL = postData.postImage {
            let image = URL(string: postImageURL)
            let placeholder = UIImage(named: "photo")
            self.postView.postImage.sd_setImage(with: image, placeholderImage: placeholder)
        } else {
            self.postView.postImage.image = UIImage(named: "photo")
        }
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
