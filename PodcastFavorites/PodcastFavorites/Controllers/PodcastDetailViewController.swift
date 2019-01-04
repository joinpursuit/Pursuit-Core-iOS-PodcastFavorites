//
//  PodcastDetialViewController.swift
//  PodcastFavorites
//
//  Created by Alex Paul on 1/3/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class PodcastDetailViewController: UIViewController {
  
  @IBOutlet weak var favoriteButton: UIBarButtonItem!
  @IBOutlet weak var podcastImage: UIImageView!
  
  public var podcast: Podcast!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = podcast.collectionName
    updateUI()
  }
  
  private func updateUI() {
    if let image = ImageHelper.shared.image(forKey: podcast.artworkUrl600.absoluteString as NSString) {
      podcastImage.image = image
    } else {
      ImageHelper.shared.fetchImage(urlString: podcast.artworkUrl600.absoluteString) { (appError, image) in
        if let appError = appError {
          print(appError.errorMessage())
        } else if let image = image {
          self.podcastImage.image = image
        }
      }
    }
  }
  
  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func addToFavorites(_ sender: UIBarButtonItem) {
    // required parameters for favoriting
    // trackId, favoritedBy, collectionName, artworkUrl600
    let favorite = Favorite.init(trackId: podcast.trackId, favoritedBy: "NAME GOES HERE....", collectionName: podcast.collectionName, artworkUrl600: podcast.artworkUrl600)
    
    // encode the favorite object as Data to send to the API
    // using JSONEncoder()
    do {
      let data = try JSONEncoder().encode(favorite)
      PodcastAPIClient.favoritePodcast(data: data) { (appError, success) in
        if let appError = appError {
          DispatchQueue.main.async {
            self.showAlert(title: "Error Message", message: appError.errorMessage())
          }
        } else if success {
          DispatchQueue.main.async {
            self.showAlert(title: "successfully favorited podcast", message: "")
          }
        } else {
          DispatchQueue.main.async {
            self.showAlert(title: "was not favorited", message: "")
          }
        }
      }
    } catch {
      print("encoding error: \(error)")
    }
  }
}
