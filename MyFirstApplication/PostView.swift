//
//  PostView.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 09.05.2022.
//

import UIKit

class PostView: UIView {
    // MARK: - Properties
    
    let kCONTENT_XIB_NAME = "PostView"
    weak var delegate: PostTableViewCellDelegate? 
    var post: Post?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timePassed: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var numCommentsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func shareButton(_ sender: Any) {
        guard let post = self.post else { return }
        
        delegate?.shouldShare(post: post)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let post = self.post else { return }
        delegate?.shouldSaveUnsavePost(post: post)
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

/*
// Only override draw() if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func draw(_ rect: CGRect) {
    // Drawing code
}
*/
