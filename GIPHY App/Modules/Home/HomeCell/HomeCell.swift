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
  var gifData: Data?
  var gifUrl: String?
  var currentTask: URLSessionDataTask?

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func updateViews() {
    gifImgView.image = nil
    activityIndicator.isHidden = false
    titleLabel.text = cellPresentation.name
    if let gifData = gifData, gifUrl == cellPresentation.imgUrl {
      DispatchQueue.global(qos: .userInitiated).async {
        let image = UIImage.gif(data: gifData)!
        DispatchQueue.main.async {
          self.gifImgView.image = image
          self.activityIndicator.isHidden = true
        }
      }
    } else {
      guard let imgUrl = URL(string: cellPresentation.imgUrl) else {
        // some error
        activityIndicator.isHidden = true
        return
      }
      self.gifUrl = cellPresentation.imgUrl
      DispatchQueue.global(qos: .userInitiated).async {
        self.currentTask = URLSession.shared.dataTask(with: imgUrl, completionHandler: { (data, _, _) in
          guard let data = data else { return }
          self.gifData = data
          let image = UIImage.gif(data: data)
          DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.gifImgView.image = image
          }
        })
        self.currentTask?.resume()
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    updateViews()
  }
  
}
