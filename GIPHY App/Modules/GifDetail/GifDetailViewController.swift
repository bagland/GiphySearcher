//
//  GifDetailViewController.swift
//  GIPHY App
//
//  Created Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GifDetailViewController: UIViewController, GifDetailViewProtocol {
  @IBOutlet weak var gifImgView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  var presenter: GifDetailPresenterProtocol?
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter?.viewDidLoad()
  }
  
  @IBAction func didTapCloseButton(_ sender: Any) {
    presenter?.didTapClose()
  }
  
  func showGifImage(_ image: UIImage) {
    gifImgView.image = image
  }
  
  func updateWithTitle(_ title: String?) {
    titleLabel.text = title
  }
}
