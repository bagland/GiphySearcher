//
//  HomeInteractor.swift
//  GIPHY App
//
//  Created Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import RxSwift


class HomeInteractor: HomeInteractorInputProtocol {
  var presenter: HomeInteractorOutputProtocol?
  
  func searchGiphyWithQuery(_ query: String) -> Observable<[GiphyEntity]> {
    return Observable.create({ (observer) -> Disposable in
      let dbResult = DatabaseManager.shared.loadGiphiesFor(searchQuery: query)
      if dbResult.count > 0 {
        observer.onNext(dbResult)
      }
      let request = GiphyService.searchForQuery(query, offset: nil, completion: { (networkResult) in
        switch networkResult {
        case .Success(let giphyArray):
          DatabaseManager.shared.insertGiphiesFor(searchQuery: query, giphies: giphyArray)
          observer.onNext(giphyArray)
        case .Failure(let error):
          // show error only if nothing found in DB
          if dbResult.count == 0 {
            self.presenter?.gotError(error: error)
          }
        }
      })
      return Disposables.create {
        request.cancel()
      }
    })
  }
}
