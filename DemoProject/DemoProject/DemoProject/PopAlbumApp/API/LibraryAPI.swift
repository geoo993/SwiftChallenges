//
//  LibraryAPI.swift
//  RWBlueLibrary
//
//  Created by GEORGE QUENTIN on 10/05/2019.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//
import Foundation
import UIKit

final class LibraryAPI {
  
  // 1 - SINGLETON PATTERN: The shared static constant approach gives other objects access to the singleton object LibraryAPI.
  static let shared = LibraryAPI() //SINGLETON PATTERN
  
  // 2- The private initializer prevents creating new instances of LibraryAPI from outside.
  private init() {
    
    // This is the other side of the OBSERVER PATTERN: the observer/subscriber. Every time an AlbumView posts a BLDownloadImage notification, since LibraryAPI has registered as an observer for the same notification, the system notifies LibraryAPI. Then LibraryAPI calls downloadImage(with:) in response.
    // the publisher of notification is AlbumView, who send messages to this LibraryAPI observer.
    // The publisher AlbumView, never needs to know anything about the subscribers.
    NotificationCenter.default
      .addObserver(self, selector: #selector(downloadImage(with:)), name: .BLDownloadImage, object: nil)
  }
  
  // 3 - FACADE PATTERN: We create provides a single interface/class LibraryAPI to a complex subsystem.
  // Instead of exposing the user to a set of classes and their APIs (i.e. PersistencyManager, HTTPClient),
  // you only expose one simple unified API (i.e. LibraryAPI).
  private let persistencyManager = PersistencyManager()
  private let httpClient = HTTPClient()
  private let isOnline = false
  
  func getAlbums() -> [Album] {
    return persistencyManager.getAlbums()
  }
  
  // This class first updates the data locally, and then if there’s an internet connection, it updates the remote server.
  // This is the real strength of the Facade;
  // when some class outside of your system adds a new album, it doesn’t know — and doesn’t need to know — of the complexity that lies underneath.
  func addAlbum(_ album: Album, at index: Int) {
    persistencyManager.addAlbum(album, at: index)
    if isOnline {
      httpClient.postRequest("/api/addAlbum", body: album.description)
    }
  }
  
  func deleteAlbum(at index: Int) {
    persistencyManager.deleteAlbum(at: index)
    if isOnline {
      httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
    }
  }
  
  @objc func downloadImage(with notification: Notification) {
    guard let userInfo = notification.userInfo,
      let imageView = userInfo["imageView"] as? UIImageView,
      let coverUrl = userInfo["coverUrl"] as? String,
      let filename = URL(string: coverUrl)?.lastPathComponent else {
        return
    }
    
    if let savedImage = persistencyManager.getImage(with: filename) {
      imageView.image = savedImage
      return
    }
    
    DispatchQueue.global().async {
      let downloadedImage = self.httpClient.downloadImage(coverUrl) ?? UIImage()
      DispatchQueue.main.async {
        imageView.image = downloadedImage
        self.persistencyManager.saveImage(downloadedImage, filename: filename)
      }
    }
  }
  


}
