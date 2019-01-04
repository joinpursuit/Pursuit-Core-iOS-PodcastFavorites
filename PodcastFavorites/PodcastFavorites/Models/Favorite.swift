//
//  Favorite.swift
//  PodcastFavorites
//
//  Created by Alex Paul on 1/3/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct Favorite: Codable {
  let trackId: Int
  let favoritedBy: String
  let collectionName: String
  let artworkUrl600: URL
}
