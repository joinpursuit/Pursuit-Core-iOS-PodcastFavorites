//
//  FavoritesViewController.swift
//  PodcastFavorites
//
//  Created by Alex Paul on 1/3/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var favorites = [Favorite]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    fetchFavorites()
  }
  
  private func fetchFavorites() {
    guard let encodedName = "Alex Paul".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
      return
    }
    PodcastAPIClient.getFavorites(name: encodedName) { (appError, favorites) in
      if let appError = appError {
        print(appError.errorMessage())
      } else if let favorites = favorites {
        self.favorites = favorites
      }
    }
  }
  
}

extension FavoritesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
    let favorite = favorites[indexPath.row]
    cell.textLabel?.text = favorite.collectionName
    if let image = ImageHelper.shared.image(forKey: favorite.artworkUrl600.absoluteString as NSString) {
      cell.imageView?.image = image
    } else {
      ImageHelper.shared.fetchImage(urlString: favorite.artworkUrl600.absoluteString) { (appError, image) in
        if let appError = appError {
          print(appError.errorMessage())
        } else if let image = image {
          cell.imageView?.image = image
        }
      }
    }
    return cell
  }
}
