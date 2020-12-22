//
//  ImageInfo.swift
//  PixabayApp
//
//  Created by Клим on 07.12.2020.
//

import Foundation

struct ImageInfo: Decodable{
    var id: Int
    var tags: String
    var previewURL: URL?
    var largeImageURL: URL?
    var views: Int
    var likes: Int
    var comments: Int
    var user: String
    var userImageURL: String

}
