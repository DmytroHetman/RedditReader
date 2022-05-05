//
//  PostListViewController.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 19.04.2022.
//

import UIKit

class PostListViewController: UIViewController {
    
    // MARK: Const
    struct Const {
        static let cellReuseId = "post_table_cell"
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        
    }
    
    
}

extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseId, for: indexPath) as! PostTableViewCell
        
        return cell
    }
    
   
    
    
}


