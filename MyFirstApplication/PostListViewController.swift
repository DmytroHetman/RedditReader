//
//  PostListViewController.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 19.04.2022.
//

import UIKit

class PostListViewController: UIViewController {
    
    // MARK: Const
    private struct Const {
        static let cellReuseId = "post_table_cell"
        static let segueIdentifier = "post_details"
        static let subreddit = "ios"
        static let limit = 10
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navigationArea: UINavigationItem!
    @IBOutlet private weak var savedPostsButton: UIBarButtonItem!
    
    
    // MARK: - Properties
    private var portionOfPosts: [Post] = []
    private var after = ""
    private var isLoadingData = false
    private let request = Request()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadsPosts()
        view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.frame = view.bounds
        
    }

}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Const.segueIdentifier,
           let destination = segue.destination as? PostDetailsViewController,
           let postIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.post = portionOfPosts[postIndex]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portionOfPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseId, for: indexPath) as! PostTableViewCell
        cell.config(from: self.portionOfPosts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Const.segueIdentifier, sender: nil)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        loadsMorePosts()
        print("LOADED")
    }
    
    private func loadsPosts() {
        request.fetchData(
            subreddit: Const.subreddit,
            limit: Const.limit,
            after: self.after) {
            postData in
                self.portionOfPosts = postData
                self.after = postData.last?.after ?? ""
                
                DispatchQueue.main.async {
                    self.title = "/r/\(Const.subreddit)"
                    self.tableView.reloadData()
                }
            }
            
    }
    
    private func loadsMorePosts() {
        self.request.fetchData(
            subreddit: Const.subreddit,
            limit: Const.limit,
            after: self.after) {
            postData in
                self.portionOfPosts.append(contentsOf: postData)
                self.after = self.portionOfPosts.last?.after ?? ""
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
    }
    
}


