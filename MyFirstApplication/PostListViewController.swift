//
//  PostListViewController.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 19.04.2022.
//

import UIKit

class PostListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navigationArea: UINavigationItem!
    @IBOutlet private weak var savedPostsButton: UIBarButtonItem!
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - IBActions
    @IBAction func savedPostsButton(_ sender: Any) {
        self.savedPostsShown.toggle()
        self.startTop()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.tableView.isScrollEnabled = !self.activeData.isEmpty
    }
    
    // MARK: - Properties
    private var after: String {
        ActiveSessionPosts.shared.posts.last?.after ?? ""
    }
    private var activeData: [Post] {
        PostRepository.shared.updateUIData(savedPostsShown: self.savedPostsShown)
    }
    private var savedPostsShown: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            //self.textField.isHidden = true
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.frame = self.view.bounds
            self.title = "/r/\(Constants.subreddit)"
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PostRepository.shared.savedPosts = PostRepository.shared.savedPosts.filter { $0.saved }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            //self.textField.becomeFirstResponder()
        }
    }
    
}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PostTableViewCellDelegate  {
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifier,
           let destination = segue.destination as? PostDetailsViewController,
           let postIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.post = activeData[postIndex]
        }
        
    }
    
    //MARK: - tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueIdentifier, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.activeData.count == 0 {
            self.tableView.setMessage("No saved posts ")
        } else {
            self.tableView.clearBackground()
        }
        return self.activeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as! PostTableViewCell
        cell.config(from: self.activeData[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !savedPostsShown {
            PostRepository.shared.loadsPosts(after: self.after)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func updateUI() {
        self.savedPostsButton.image = UIImage(systemName: self.savedPostsShown ? "bookmark.circle.fill" : "bookmark.circle")
        self.title = "/r/\(Constants.subreddit)"
        self.textField.isHidden = !self.savedPostsShown
        self.tableView.reloadData()
    }
    
    private func startTop() {
        DispatchQueue.main.async {
            guard !self.activeData.isEmpty else { return }
            let topRow = IndexPath(row: 0,
                                   section: 0)
            self.tableView.scrollToRow(at: topRow,
                                       at: .top,
                                       animated: false)
        }
    }
    
    
    // MARK: - Buttons actions
    func shouldShare(post: Post) {
        let postURL = post.url
        let ac = UIActivityViewController(activityItems: [postURL], applicationActivities: [])
        present(ac, animated: true)
    }
    
    func shouldSaveUnsavePost(post: Post) {
        PostRepository.shared.saveUnsaveToggle(post: post)
        guard let numOfPost = self.savedPostsShown ? PostRepository.shared.savedPosts.firstIndex(where: {post.id == $0.id }) : ActiveSessionPosts.shared.posts.firstIndex(where: {post.id == $0.id }) else { return }
        let indexPath = IndexPath(row: numOfPost, section: 0)
        if self.savedPostsShown && !PostRepository.shared.savedPosts.contains(post) {
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        PostRepository.shared.saveUnsavePost(post: self.activeData[numOfPost])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - textField
    
    
}

extension UITableView {

    func setMessage(_ message: String) {
        let lblMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        lblMessage.text = message
        lblMessage.textColor = .black
        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont(name: "TrebuchetMS", size: 15)
        lblMessage.sizeToFit()

        self.backgroundView = lblMessage
        self.separatorStyle = .none
    }

    func clearBackground() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


