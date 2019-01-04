//
//  Podcast.swift
//  PodcastFavorites
//
//  Created by Alex Paul on 1/3/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct PodcastData: Codable {
  let resultCount: Int
  let results: [Podcast]
}

struct Podcast: Codable {
  let trackId: Int
  let artistName: String
  let collectionName: String
  let artworkUrl600: URL
}
