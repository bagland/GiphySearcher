//
//  GiphyService.swift
//  GIPHY App
//
//  Created by Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum GiphyError: Error {
  case ResponseError
  case NoNetworkError
}

enum NetworkResult<T>{
  case Success(T)
  case Failure(Error)
}

class GiphyService {
  static func searchForQuery(_ query: String, offset: Int?, completion: @escaping(NetworkResult<[GiphyEntity]>) -> Void) -> DataRequest {
    let giphyUrl = "https://api.giphy.com/v1/gifs/search"
    var params: Parameters = [
      "q": query,
      "api_key": Constants.apiKey,
    ]
    if let offset = offset {
      params["offset"] = offset
    }
    
    return Alamofire.request(giphyUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
      .responseJSON(completionHandler: { (response) in
        switch response.result {
        case .success(let value):
          guard let val = value as? [String: Any],
            let data = val["data"] as? [[String: Any]] else {
              completion(NetworkResult.Failure(GiphyError.ResponseError))
              return
          }
          let items = Mapper<GiphyEntity>().mapArray(JSONArray: data)
          completion(NetworkResult.Success(items))
        case .failure(let error):
          if let error = error as? NSError {
            if error.code == NSURLErrorNotConnectedToInternet {
              completion(NetworkResult.Failure(GiphyError.NoNetworkError))
            } else {
              completion(NetworkResult.Failure(error))
            }
          }
        }
      })
  }
}

