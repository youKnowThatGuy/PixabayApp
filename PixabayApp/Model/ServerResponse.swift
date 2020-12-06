//
//  ServerResponse.swift
//  PixabayApp
//
//  Created by Клим on 07.12.2020.
//

import Foundation

struct ServerResponse<Object:Decodable>: Decodable {
    var hits: [Object]
}
