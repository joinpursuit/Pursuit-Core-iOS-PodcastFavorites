//
//  PodcastCell.swift
//  PodcastFavorites
//
//  Created by Alex Paul on 1/3/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
  
  @IBOutlet weak var podcastImage: UIImageView!
  @IBOutlet weak var podcastCollectionName: UILabel!
  @IBOutlet weak var podcastArtistName: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private var urlString = ""
  
  public func configureCell(podcast: Podcast) {
    
    urlString = podcast.artworkUrl600.absoluteString
    
    podcastCollectionName.text = podcast.collectionName
    podcastArtistName.text = podcast.artistName
    if let image = ImageHelper.shared.image(forKey: podcast.artworkUrl600.absoluteString as NSString) {
      podcastImage.image = image
    } else {
      activityIndicator.startAnimating()
      ImageHelper.shared.fetchImage(urlString: podcast.artworkUrl600.absoluteString) { (appError, image) in
        if let appError = appError {
          print(appError.errorMessage())
        } else if let image = image {
          if self.urlString == podcast.artworkUrl600.absoluteString {
            self.podcastImage.image = image
          }
        }
        self.activityIndicator.stopAnimating()
      }
    }
  }
  
}
