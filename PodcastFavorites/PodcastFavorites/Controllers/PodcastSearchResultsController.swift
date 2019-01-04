//
//  ViewController.swift
//  PodcastFavorites
//
//  Created by Alex Paul on 1/3/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class PodcastSearchResultsController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  private var podcasts = [Podcast]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    searchPodcast(keyword: "swift")
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
  }
  
  private func searchPodcast(keyword: String) {
    PodcastAPIClient.searchPodcast(keyword: keyword) { (appError, podcasts) in
      if let appError = appError {
        print(appError.errorMessage())
      } else if let podcasts = podcasts {
        self.podcasts = podcasts
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let indexPath = tableView.indexPathForSelectedRow,
      let detailViewController = segue.destination as? PodcastDetailViewController else {
        fatalError("indexPath, detailVC nil")
    }
    let podcast = podcasts[indexPath.row]
    detailViewController.podcast = podcast
  }
}

extension PodcastSearchResultsController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcasts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath) as? PodcastCell else {
      fatalError("PodcastCell error")
    }
    let podcast = podcasts[indexPath.row]
    cell.configureCell(podcast: podcast)
    return cell
  }
}

extension PodcastSearchResultsController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

extension PodcastSearchResultsController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let text = searchBar.text,
     let encodedSearchText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
      return
    }
    searchPodcast(keyword: encodedSearchText)
  }
}

