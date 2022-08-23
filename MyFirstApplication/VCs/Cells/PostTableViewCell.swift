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
    var post: Post?
    private var supplementaryView: UIView?
    
    // MARK: - Selection
    
    
    
    // MARK: Config
    
    func config(from postData: Post) {
        
            self.post = postData
            self.postView.post = postData
            self.postView.username.text = postData.username
            self.postView.timePassed.text = postData.timePassed
            self.postView.domain.text = postData.domain
            self.postView.postTitle.text = postData.title
            self.postView.ratingButton.setTitle(postData.rating, for: .normal)
            self.postView.numCommentsButton.setTitle(postData.numComments, for: .normal)
            if let postImageURL = postData.image {
                let image = URL(string: postImageURL)
                let placeholder = UIImage(named: "placeholder")
                self.postView.postImage.sd_setImage(with: image, placeholderImage: placeholder)
            } else {
                self.postView.postImage.image = UIImage(named: "placeholder")
            }
            
            if !postData.saved {
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            } else {
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            self.configureImageView()
            
       
        self.contentView.layoutIfNeeded()
    }
    
    private func configureImageView() {
        self.postView.postImage.isUserInteractionEnabled = true
//        if supplementaryView == nil {
//            supplementaryView = BigBookmark.setImageToSupplementaryView(for: self.postView.postImage)
//        }
        setImageGestureListener()
    }
    
    private func setImageGestureListener() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(showBookmarkBySaving))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delaysTouchesBegan = true
        self.postView.postImage.addGestureRecognizer(doubleTap)
    }
    
    @objc
    private func showBookmarkBySaving() {
        guard let post = self.post else { return }
        if !post.saved {
            DispatchQueue.main.async {
                
                self.savedWithAnimation(post)
                
            }
            
        }
    }
    
    
    
    private func savedWithAnimation(_ post: Post) {
        if supplementaryView == nil {
            supplementaryView = BigBookmark.setImageToSupplementaryView(for: postView.postImage)
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
                self.supplementaryView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.supplementaryView?.alpha = 1.0
            }) { finished in
                self.supplementaryView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {() -> Void in
                    
                    self.supplementaryView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                }, completion: {(_ finished: Bool) -> Void in
                    self.supplementaryView?.transform = CGAffineTransform(scaleX: 0, y: 0)
                    self.supplementaryView?.alpha = 0.0
                    self.delegate?.shouldSaveUnsavePost(post: post)
                })
                
            }
        
    }

}


