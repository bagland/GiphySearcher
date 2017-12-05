//
//  HomeRouter.swift
//  GIPHY App
//
//  Created Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class HomeRouter: HomeWireframeProtocol {
  
  weak var viewController: UIViewController?
  
  static func createModule() -> UIViewController {
    // Change to get view from storyboard if not using progammatic UI
    let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
    let view = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    let interactor = HomeInteractor()
    let router = HomeRouter()
    let presenter = HomePresenter(interface: view, interactor: interactor, router: router)
    
    view.presenter = presenter
    interactor.presenter = presenter
    router.viewController = view
    
    let navVC = UINavigationController(rootViewController: view)
    return navVC
  }
  
  func showGifDetails(giphy: GiphyEntity) {
    let gifDetails = GifDetailRouter.createModule(giphy: giphy)
    viewController?.present(gifDetails, animated: true, completion: nil)
  }
}
