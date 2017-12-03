//
//  GiphyEntity.swift
//  GIPHY App
//
//  Created by Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//

import Foundation
import ObjectMapper

class GiphyEntity: Mappable {
  
  var ID: String!
  var title: String?
  var type: String?
  var smallImgUrl: String?
  var originalImgUrl: String?
  var source: String?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    ID <- map["id"]
    title <- map["title"]
    type <- map["type"]
    smallImgUrl <- map["images.fixed_width_small.url"]
    originalImgUrl <- map["images.original.url"]
    source <- map["source"]
  }
}

