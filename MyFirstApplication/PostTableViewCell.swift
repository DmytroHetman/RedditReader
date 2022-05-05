//
//  PostTableViewCell.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 04.05.2022.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var postImage: UIImageView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var timePassed: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var ratingButton: UIButton!
    
    // MARK: Config
    
    func config() {
        
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
