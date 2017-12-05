//
//  DatabaseManager.swift
//  GIPHY App
//
//  Created by Baglan on 12/5/17.
//  Copyright © 2017 Baglan. All rights reserved.
//

import Foundation
import FMDB

class DatabaseManager: NSObject {
  static let shared: DatabaseManager = DatabaseManager()
  let filename = "giphy.sqlite"
  var dbPath: String!
  var database: FMDatabase!
  
  struct Fields {
    static let giphyID = "giphyID"
    static let title = "title"
    static let query = "query"
    static let smallImgUrl = "smallImgUrl"
    static let originalImgUrl = "originalImgUrl"
    static let smallImgData = "smallImgData"
  }
  
  override init() {
    super.init()
    
    let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    dbPath = documentsDir.appending("/\(filename)")
  }
  
  func createDatabase() -> Bool {
    var created = false
    if !FileManager.default.fileExists(atPath: dbPath) {
      database = FMDatabase(path: dbPath)
      if database != nil {
        if database.open() {
          let createTableStatement = "create table giphies (\(Fields.giphyID) text primary key not null, \(Fields.title) text not null, \(Fields.query) text not null, \(Fields.smallImgUrl) text, \(Fields.originalImgUrl) text not null, \(Fields.smallImgData) blob)"
          do {
            try database.executeUpdate(createTableStatement, values: nil)
            created = true
          } catch {
            debugPrint("Couldn't create giphies table.")
            debugPrint(error)
          }
          database.close()
        } else {
          debugPrint("error on opening the database")
        }
      }
    }
    return created
  }
  
  func dbExists() -> Bool {
    return FileManager.default.fileExists(atPath: dbPath)
  }
  
  func openDatabase() -> Bool {
    if database == nil {
      if FileManager.default.fileExists(atPath: dbPath) {
        database = FMDatabase(path: dbPath)
      }
    }
    
    if database != nil {
      if database.open() {
        return true
      }
    }
    
    return false
  }
  
  func insertGiphiesFor(searchQuery: String, giphies: [GiphyEntity]) {
    // don't do anything if query returned no giphies
    guard giphies.count > 0 else {
      return
    }
    var databaseQuery = ""
    if openDatabase() {
      for giphy in giphies {
        let smallImgUrl = giphy.smallImgUrl ?? ""
        let originalImgUrl = giphy.originalImgUrl ?? ""
        databaseQuery += "insert or replace into giphies(\(Fields.giphyID), \(Fields.title), \(Fields.query), \(Fields.smallImgUrl), \(Fields.originalImgUrl)) values ('\(giphy.ID)', '\(giphy.title!)', '\(searchQuery)', '\(smallImgUrl)', '\(originalImgUrl)');"
      }
      
      if !database.executeStatements(databaseQuery) {
        debugPrint("Error on insert!")
        debugPrint(database.lastError(), database.lastErrorMessage())
      }
      database.close()
    }
  }
  
  func insertImgDataFor(imgUrl: String, imgData: Data) {
    if openDatabase() {
      let updateQuery = "update giphies set \(Fields.smallImgData) = ? where \(Fields.smallImgUrl) = ?;"
      do {
        try database.executeUpdate(updateQuery, values: [imgData, imgUrl])
      } catch {
        debugPrint("Error on saving imgData!")
        debugPrint(database.lastError(), database.lastErrorMessage())
      }
      database.close()
    }
  }
  
  func loadImgDataFor(imgUrl: String) -> Data? {
    if openDatabase() {
      let query = "select * from giphies where \(Fields.smallImgUrl) = ?;"
      do {
        let results = try database.executeQuery(query, values: [imgUrl])
        if results.next() {
          return results.data(forColumn: Fields.smallImgData)
        }
      } catch {
        debugPrint(error)
      }
    }
    
    return nil
  }
  
  func loadGiphiesFor(searchQuery: String) -> [GiphyEntity] {
    var giphies = [GiphyEntity]()
    
    if openDatabase() {
      let query = "select * from giphies where \(Fields.query) = ?;"
      do {
        let results = try database.executeQuery(query, values: [searchQuery])
        while results.next() {
          let giphy = GiphyEntity(JSON: [:])!
          giphy.ID = results.string(forColumn: Fields.giphyID)
          giphy.title = results.string(forColumn: Fields.title)
          giphy.smallImgUrl = results.string(forColumn: Fields.smallImgUrl)
          giphy.originalImgUrl = results.string(forColumn: Fields.originalImgUrl)
          giphies.append(giphy)
        }
      } catch {
        debugPrint(error)
      }
      
      database.close()
    }
  
    return giphies
  }
  
}
