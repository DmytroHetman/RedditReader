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
    
    
    
    // MARK: - IBActions
    @IBAction func savedPostsButton(_ sender: Any) {
        self.savedPostsShown.toggle()
        self.startTop()
        self.tableView.isScrollEnabled = !self.activeData.isEmpty
        self.reloadDataAsync()
    }
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    private var after: String? {
        if ActiveSessionPosts.shared.posts.last?.after != "" {
            return ActiveSessionPosts.shared.posts.last?.after
        }
        return nil
    }
    var postToDeleteFromFiltered: Post?
    private var postsTitlesFiltered: [Post] = [] {
        didSet {
            postsFilteredHandler?()
        }
    }
    var postsFilteredHandler: (() -> Void)?
    private var activeData: [Post] {
        if PostRepository.shared.isSearching {
            self.postsFilteredHandler?()
            return self.postsTitlesFiltered
        }
        return self.savedPostsShown ? PostRepository.shared.savedPosts : ActiveSessionPosts.shared.posts
    }
    
    private var savedPostsShown: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    private var loadingData = false
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            
            self.title = "/r/\(Const.subreddit)"
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.frame = self.view.bounds
            self.navigationArea.searchController = nil
            self.searchController.searchBar.delegate = self
            self.searchController.searchBar.autocapitalizationType = .none
            
        }
        self.reloadDataAsync()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let postToDeleteFromFiltered = postToDeleteFromFiltered {
            if !postToDeleteFromFiltered.saved {
                if let row = self.postsTitlesFiltered.firstIndex(where: { $0.id == postToDeleteFromFiltered.id }) {
                    self.postsTitlesFiltered.removeAll(where: { $0.id == postToDeleteFromFiltered.id })
                    let indexPath = IndexPath(row: row, section: 0)
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
        self.reloadDataAsync()
    }
    
}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, PostTableViewCellDelegate  {
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Const.segueIdentifier,
           let destination = segue.destination as? PostDetailsViewController,
           let postIndex = self.tableView.indexPathForSelectedRow?.row
        {
            destination.post = self.activeData[postIndex]
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Const.segueIdentifier, sender: nil)
    }
    
    //MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseId, for: indexPath) as! PostTableViewCell
        cell.delegate = self
        cell.config(from: self.activeData[indexPath.row])
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.savedPostsShown, !self.loadingData, (self.tableView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height {
            loadsPosts()
        }
    }
    
    func loadsPosts() {
        self.loadingData = true
        guard let after = self.after else { return }
        Request.shared.fetchData(
            subreddit: Const.subreddit,
            limit: Const.limit,
            after: after) { postsData in
                self.loadingData = false
                ActiveSessionPosts.shared.posts.append(contentsOf: postsData)
                ActiveSessionPosts.shared.postsLoadedHandler = {
                    self.reloadDataAsync()
                }
            }
    }

    func updateUI() {
        self.savedPostsButton.image = UIImage(systemName: self.savedPostsShown ? "bookmark.circle.fill" : "bookmark.circle")
        if PostRepository.shared.savedPosts.count == 0 {
            self.tableView.setMessage("No saved posts")
        } else {
            self.tableView.clearBackground()
        }
        
        self.title = "/r/\(Const.subreddit)"
        self.navigationArea.searchController = self.savedPostsShown ? self.searchController : nil
        self.tableView.reloadSections(IndexSet(0..<1), with: .automatic)
        self.reloadDataAsync()
    }
    
    private func startTop() {
        DispatchQueue.main.async {
            guard !self.activeData.isEmpty else { return }
            let topRow = IndexPath(
                row: 0,
                section: 0
            )
            self.tableView.scrollToRow(
                at: topRow,
                at: .top,
                animated: false
            )
        }
    }
    
    
    // MARK: - Buttons actions
    func shouldShare(post: Post) {
        let postURL = post.url
        let ac = UIActivityViewController(activityItems: [postURL], applicationActivities: [])
        present(ac, animated: true)
    }
    
    func shouldSaveUnsavePost(post: Post) {
        
        PostRepository.shared.saveUnsavePost(post: post)
        
        if PostRepository.shared.isSearching {
            
            self.postsTitlesFiltered.removeAll(where: {$0 == post})
            self.postsFilteredHandler?()
            guard let row = self.activeData.firstIndex(where: { $0 == post }) else { return }
            
            let indexPath = IndexPath(row: row, section: 0)
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else if self.savedPostsShown && !PostRepository.shared.savedPosts.contains(post) {
            guard let row = PostRepository.shared.savedPosts.firstIndex(where: { $0 == post }) else { return }
            let indexPath = IndexPath(row: row, section: 0)
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
    }

    // MARK: - searchBar
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        PostRepository.shared.isSearching = false
        self.postsFilteredHandler?()
//        searchBar.text = ""
//        searchBar.endEditing(true)
        self.reloadDataAsync()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        PostRepository.shared.isSearching = true
        guard let text = searchBar.text, !text.isEmpty else {
            self.postsTitlesFiltered = PostRepository.shared.savedPosts
            self.reloadDataAsync()
            return
        }
        
        self.postsTitlesFiltered = PostRepository.shared.savedPosts.filter { $0.title.lowercased().contains(text.lowercased()) }
        self.postsFilteredHandler?()
        self.reloadDataAsync()
    }
    
    
    private func reloadDataAsync() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
    
}


extension UITableView {
    
    // MARK: - IF savedPosts.isEmpty
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


