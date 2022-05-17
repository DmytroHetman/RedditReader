//
//  PostTableViewCellDelegate.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 12.05.2022.
//

import Foundation

protocol PostTableViewCellDelegate: AnyObject {
    func shouldShare(post: Post)
    func shouldSaveUnsavePost(post: Post)
}
