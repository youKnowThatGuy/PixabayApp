//
//  ImageInfo.swift
//  PixabayApp
//
//  Created by Клим on 07.12.2020.
//

import Foundation

struct ImageInfo: Decodable{
    var id: Int
    var previewURL: URL?
    var fullSizeURL: URL?
}
