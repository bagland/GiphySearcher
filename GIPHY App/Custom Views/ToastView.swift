//
//  ToastView.swift
//  GIPHY App
//
//  Created by Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//

import UIKit

class ToastView: UIView {
  let imageView = UIImageView()
  let messageLabel = UILabel()
  var tryAgainButton: UIButton?
  var message: String = ""
  var image: UIImage?
  var showButton: Bool = false
  var tryAgainCompletion: (() -> ())?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  init(message: String, image: UIImage?, showButton: Bool = false) {
    super.init(frame: CGRect.zero)
    self.message = message
    self.image = image
    self.showButton = showButton
    
    commonInit()
  }
  
  private func commonInit() {
    backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
    layer.cornerRadius = 5.0
    layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 1.0
    
    if showButton {
      setupButton()
    }
    setupImageView()
    setupMessageLabel()
  }
  
  private func setupImageView() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    if let image = image {
      imageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
      imageView.image = image
    } else {
      imageView.widthAnchor.constraint(equalToConstant: 0.0).isActive = true
    }
    imageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0).isActive = true
    imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  private func setupButton() {
    tryAgainButton = UIButton(type: .system)
    tryAgainButton!.translatesAutoresizingMaskIntoConstraints = false
    addSubview(tryAgainButton!)
    tryAgainButton!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
    tryAgainButton!.setTitle(Constants.tryAgain, for: .normal)
    tryAgainButton!.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0).isActive = true
    tryAgainButton!.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    tryAgainButton!.addTarget(self, action: #selector(didTapTryAgain), for: .touchUpInside)
  }
  
  @objc private func didTapTryAgain() {
    if let completion = tryAgainCompletion {
      completion()
    }
  }
  
  private func setupMessageLabel() {
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(messageLabel)
    messageLabel.font = UIFont.systemFont(ofSize: 14.0)
    messageLabel.text = message
    messageLabel.textColor = UIColor.white
    messageLabel.numberOfLines = 0
    messageLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8.0).isActive = true
    if showButton {
      messageLabel.rightAnchor.constraint(equalTo: tryAgainButton!.rightAnchor, constant: -8.0).isActive = true
    } else {
      messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0).isActive = true
    }
    messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  
}
