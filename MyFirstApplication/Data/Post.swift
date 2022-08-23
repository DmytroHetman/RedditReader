//
//  Post.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 06.05.2022.
//

import Foundation

struct Post: Identifiable, Hashable, Codable {
    
    let username: String
    let timePassed: String
    let domain: String
    let title: String
    let image: String?
    let rating: String
    let numComments: String
    let after: String
    let url: String
    var saved: Bool
    let id: String
    let name: String
    
}


