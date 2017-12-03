//
//  GifDetailInteractor.swift
//  GIPHY App
//
//  Created Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Alamofire

class GifDetailInteractor: GifDetailInteractorInputProtocol {
  var presenter: GifDetailInteractorOutputProtocol?
  
  func loadGif(url: String) {
    Alamofire.request(url)
      .responseData { (response) in
        guard response.error == nil else {
          self.presenter?.gotError()
          return
        }
        guard let data = response.data else {
          self.presenter?.gotError()
          return
        }
        self.presenter?.gotGifData(data)
      }
  }
}
