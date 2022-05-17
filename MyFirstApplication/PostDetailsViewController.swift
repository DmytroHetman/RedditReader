//
//  PostViewController.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 20.02.2022.
//

import UIKit
import SDWebImage

class PostDetailsViewController: UIViewController, PostTableViewCellDelegate {
    

    // MARK: - IBOutlets
    
    @IBOutlet private weak var postView: PostView!
    
    // MARK: - Properties
    weak var delegate: PostTableViewCellDelegate? { didSet { self.postView.delegate = self.delegate } }
    var post: Post?
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.postView)
        
        self.postView.delegate = self
        
        DispatchQueue.main.async {
            guard let post = self.post else {
                print("zalupa")
                return
            }
            self.postView.post = post
            self.postView.username.text = post.username
            self.postView.timePassed.text = post.timePassed
            self.postView.domain.text = post.domain
            self.postView.postTitle.text = post.title
            self.postView.ratingButton.setTitle(post.rating, for: .normal)
            self.postView.numCommentsButton.setTitle(post.numComments, for: .normal)

            if let postImageURL = post.image {
                let image = URL(string: postImageURL)
                self.postView.postImage.sd_setImage(with: image, placeholderImage: UIImage(named: "photo"))
            } else {
                self.postView.postImage.image = UIImage(named: "photo")
            }
            
            if post.saved {
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }

            
        }
    }
    
    func shouldShare(post: Post) {
        let postURL = post.url
        let ac = UIActivityViewController(activityItems: [postURL], applicationActivities: [])
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
    
    func shouldSaveUnsavePost(post: Post) {

        self.post?.saved.toggle()

//        print("1\(self.post?.saved)")
        guard let postToSaveUnsave = self.post else { return }
        
        PostRepository.shared.saveUnsaveToggle(post: postToSaveUnsave)
//        print("4\(self.post?.saved)")
        PostRepository.shared.saveUnsavePost(post: postToSaveUnsave)
        self.postView.post = self.post

        DispatchQueue.main.async {
            guard let isSaved = self.post?.saved else { return }
            if isSaved {
//                print("2\(String(describing: self.post?.saved))")
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
//                PostRepository.shared.savedPosts.append(post)
//                print("when change button nil? \(PostRepository.shared.savedPosts.first(where: {$0.id == self.post?.id}))")
            } else {
//                print("3\(self.post?.saved)")
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
//        print(ActiveSessionPosts.shared.posts.first(where: {$0.id == self.post?.id}))
//        print("end nil? \(PostRepository.shared.savedPosts.first(where: {$0.id == self.post?.id}))")
//        print(self.post)
//        print(self.postView.post)
//        print(PostRepository.shared.savedPosts)
    }



}
