//
//  PersistencyManager.swift
//  RWBlueLibrary
//
//  Created by GEORGE QUENTIN on 10/05/2019.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//
import Foundation
import UIKit

final class PersistencyManager {
  private var albums = [Album]()
  private var documents: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  private enum Filenames {
    static let Albums = "albums.json"
  }

  init() {
    /*
    //Dummy list of albums
    let album1 = Album(title: "Best of Bowie",
                       artist: "David Bowie",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_david_bowie_best_of_bowie.png",
                       year: "1992")
    
    let album2 = Album(title: "It's My Life",
                       artist: "No Doubt",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_no_doubt_its_my_life_bathwater.png",
                       year: "2003")
    
    let album3 = Album(title: "Nothing Like The Sun",
                       artist: "Sting",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_sting_nothing_like_the_sun.png",
                       year: "1999")
    
    let album4 = Album(title: "Staring at the Sun",
                       artist: "U2",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_u2_staring_at_the_sun.png",
                       year: "2000")
    
    let album5 = Album(title: "American Pie",
                       artist: "Madonna",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_madonna_american_pie.png",
                       year: "2000")
    albums = [album1, album2, album3, album4, album5]
    */
    
    let savedURL = documents.appendingPathComponent(Filenames.Albums)
    var data = try? Data(contentsOf: savedURL)
    if data == nil, let bundleURL = Bundle.main.url(forResource: Filenames.Albums, withExtension: nil) {
      data = try? Data(contentsOf: bundleURL)
    }
    
    if let albumData = data,
      let decodedAlbums = try? JSONDecoder().decode([Album].self, from: albumData) {
      albums = decodedAlbums
      saveAlbums()
    }
  }

  // MARK:- Add, Delete and Get album
  func getAlbums() -> [Album] {
    return albums
  }

  func addAlbum(_ album: Album, at index: Int) {
    if (albums.count >= index) {
      albums.insert(album, at: index)
    } else {
      albums.append(album)
    }
  }

  func deleteAlbum(at index: Int) {
    albums.remove(at: index)
  }
  
  // MARK:- save album with JSON encoder
  func saveAlbums() {
    let url = documents.appendingPathComponent(Filenames.Albums)
    let encoder = JSONEncoder()
    guard let encodedData = try? encoder.encode(albums) else {
      return
    }
    try? encodedData.write(to: url)
  }
  
  
  
  // MARK:- Save and Load images
  private var cache: URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
  }
  
  func saveImage(_ image: UIImage, filename: String) {
    let url = cache.appendingPathComponent(filename)
    guard let data = image.pngData() else {
      return
    }
    try? data.write(to: url)
  }
  
  func getImage(with filename: String) -> UIImage? {
    let url = cache.appendingPathComponent(filename)
    guard let data = try? Data(contentsOf: url) else {
      return nil
    }
    return UIImage(data: data)
  }


}
