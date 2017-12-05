//
//  HomeCell.swift
//  GIPHY App
//
//  Created by Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//

import UIKit
import Alamofire

class HomeCell: UICollectionViewCell {
  @IBOutlet weak var gifImgView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var cellPresentation: CellPresentation!
  var currentTask: URLSessionDataTask?

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func updateViews() {
    self.activityIndicator.isHidden = true
    gifImgView.image = nil
    titleLabel.text = cellPresentation.name

    if let imgData = DatabaseManager.shared.loadImgDataFor(imgUrl: cellPresentation.imgUrl) {
      let image = UIImage.gif(data: imgData)!
      self.gifImgView.image = image
//      DispatchQueue.global(qos: .userInitiated).async {
//        let image = UIImage.gif(data: imgData)!
//        DispatchQueue.main.async {
//          self.gifImgView.image = image
//          self.activityIndicator.isHidden = true
//        }
//      }
    } else {
      guard let imgUrl = URL(string: cellPresentation.imgUrl) else {
        // some error
        activityIndicator.isHidden = true
        return
      }
      activityIndicator.isHidden = false
      URLSession.shared.dataTask(with: imgUrl, completionHandler: { (data, _, _) in
        guard let data = data else { return }
        let image = UIImage.gif(data: data)
        DispatchQueue.main.async {
          DatabaseManager.shared.insertImgDataFor(imgUrl: self.cellPresentation.imgUrl, imgData: data)
          self.activityIndicator.isHidden = true
          self.gifImgView.image = image
        }
      }).resume()
    }
    
  }
  
}
