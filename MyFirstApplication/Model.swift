//
//  PostData.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 18.02.2022.
//

import Foundation

struct Model: Codable {
    let data: ListingData
}

struct ListingData: Codable {
    let after: String
    let children: [Child]
}

struct Child: Codable {
    let data: PostData
}

struct PostData: Codable {
    let created: Double
    let ups: Int
    let downs: Int
    var rating: Int { ups + downs }
    let title: String
    let domain: String
    let author: String
    let numComments: Int
    let preview: Images?
    let name: String
    let permalink: String
    let saved: Bool
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case created
        case ups
        case downs
        case title
        case domain
        case author
        case numComments = "num_comments"
        case preview
        case name
        case permalink
        case saved
        case id
    }
}

struct Images: Codable {
    let images: [Image]
}

struct Image: Codable {
    let source: Url
}

struct Url: Codable {
    let url: String
}







