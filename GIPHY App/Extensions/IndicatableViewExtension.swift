//
//  IndicatableViewExtension.swift
//  GIPHY App
//
//  Created by Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//

import UIKit

extension IndicatableView where Self: UIViewController {
  func showNotReachableMessage(tryAgainCompletion: @escaping(() -> Void)) {
    let height: CGFloat = 60.0
    let botPadding: CGFloat = 8.0
    let toastView = ToastView(message: Constants.noInternet, image: nil, showButton: true)
    toastView.tryAgainCompletion = tryAgainCompletion
    toastView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(toastView)
    toastView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0).isActive = true
    toastView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0).isActive = true
    toastView.heightAnchor.constraint(equalToConstant: height).isActive = true
    toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: height).isActive = true
    UIView.animate(withDuration: 0.0, animations: {
      self.view.layoutIfNeeded()
    }) { (_) in
      toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -botPadding).isActive = true
      UIView.animate(withDuration: 0.5, animations: {
        self.view.layoutIfNeeded()
      })
    }
  }
}

