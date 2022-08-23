//
//  PostViewController.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 20.02.2022.
//

import UIKit
import SwiftUI
import SDWebImage

class PostDetailsViewController: UIViewController, PostTableViewCellDelegate {
    

    // MARK: - IBOutlets
    
    @IBOutlet private weak var postView: PostView!
    @IBOutlet private weak var commentsView: UIView!
    
    // MARK: - Properties
    weak var delegate: PostTableViewCellDelegate? { didSet { self.postView.delegate = self.delegate } }
    var post: Post?
    private let postRepository = PostRepository.shared
    private var supplementaryView: UIView?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.postView)
        
        self.postView.delegate = self
        self.navigationController?.delegate = self
        guard let post = self.post else { return }
        
        DispatchQueue.main.async {
            self.configurePostDetails(post: post)
            self.configureImageView()
        }
        Task {
            await self.createComments()
        }
        
    }
    
    private func createComments() async {
        
        guard let name = self.post?.name.replacingOccurrences(of: "t3_", with: "") else { fatalError() }
        let commentRepository = await CommentRepository(subreddit: Const.subreddit, limit: Const.limit, depth: Const.depth, postID: name)
        print(name)
        let host = UIHostingController(
            rootView: CommentList()
                .environmentObject(commentRepository)
        )
        guard let hostView = host.view else { return }
        self.addChild(host)
        print(hostView)
        print(commentRepository.comments)
        self.commentsView.addSubview(hostView)
        host.didMove(toParent: self)
        
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.topAnchor.constraint(equalTo: commentsView.topAnchor).isActive = true
        host.view.trailingAnchor.constraint(equalTo: commentsView.trailingAnchor).isActive = true
        host.view.leadingAnchor.constraint(equalTo: commentsView.leadingAnchor).isActive = true
        host.view.bottomAnchor.constraint(equalTo: commentsView.bottomAnchor).isActive = true
    }
    
    private func configurePostDetails(post: Post) {
        DispatchQueue.main.async {
            
            self.postView.post = post
            self.postView.username.text = post.username
            self.postView.timePassed.text = post.timePassed
            self.postView.domain.text = post.domain
            self.postView.postTitle.text = post.title
            self.postView.ratingButton.setTitle(post.rating, for: .normal)
            self.postView.numCommentsButton.setTitle(post.numComments, for: .normal)

            if let postImageURL = post.image {
                let image = URL(string: postImageURL)
                self.postView.postImage.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholder"))
            } else {
                self.postView.postImage.image = UIImage(named: "placeholder")
            }
            
            if post.saved {
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }
    
    private func configureImageView() {
        self.postView.postImage.clipsToBounds = true
        self.postView.postImage.isUserInteractionEnabled = true
//        if supplementaryView == nil {
//            supplementaryView = BigBookmark.setImageToSupplementaryView(for: self.postView.postImage)
//        }
        setImageGestureListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    // MARK: - Actions
    func shouldShare(post: Post) {
        let postURL = post.url
        let ac = UIActivityViewController(activityItems: [postURL], applicationActivities: [])
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
    
    func shouldSaveUnsavePost(post: Post) {
        
        if let post = self.post { postRepository.saveUnsavePost(post: post) }
        self.post?.saved.toggle()

        DispatchQueue.main.async {
            guard let isSaved = self.post?.saved else { return }
            if isSaved {
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                self.postView.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }
    
    private func setImageGestureListener() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(showBookmarkBySaving))
        doubleTap.numberOfTapsRequired = 2
        self.postView.postImage.addGestureRecognizer(doubleTap)
    }
    
    @objc
    private func showBookmarkBySaving() {
        guard let post = self.post else { return }
        if !post.saved { savedWithAnimation(post) }
    }
    
    private func savedWithAnimation(_ post: Post) {
        if supplementaryView == nil {
            supplementaryView = BigBookmark.setImageToSupplementaryView(for: self.postView.postImage)
        }
        print("\(post.id)")
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
                self.supplementaryView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.supplementaryView?.alpha = 1.0
            }) { finished in
                self.supplementaryView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {() -> Void in
                    self.supplementaryView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.supplementaryView?.alpha = 0.0
                }, completion: {(_ finished: Bool) -> Void in
                    self.supplementaryView?.transform = CGAffineTransform(scaleX: 0, y: 0)
                    
                })
                self.shouldSaveUnsavePost(post: post)
            }
        
    }

}



extension PostDetailsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? PostListViewController)?.postToDeleteFromFiltered = self.post
    }
}
