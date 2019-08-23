//
//  Model.swift
//  PhotosLibrary
//
//  Created by dewill on 23/08/2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import Foundation

class SearchResults: Decodable {
    let total: Int
        let results: [UnsplashPhoto]
    }

    struct UnsplashPhoto: Decodable {
        let width: Int
        let height: Int
        let urls: [URLKing.RawValue:String]
        
        
        enum URLKing: String {
            case raw
            case full
            case regular
            case small
            case thumb
        }
}
