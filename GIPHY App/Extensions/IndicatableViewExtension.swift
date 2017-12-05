//
//  IndicatableViewExtension.swift
//  GIPHY App
//
//  Created by Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//

import UIKit
import PKHUD

extension IndicatableView where Self: UIViewController {
  func showNotReachableMessage() {
    let height: CGFloat = 60.0
    let animationDuration = 0.5
    let toastView = ToastView(message: Constants.noInternet, image: nil, showButton: false)
    toastView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(toastView)
    toastView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0).isActive = true
    toastView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0).isActive = true
    toastView.heightAnchor.constraint(equalToConstant: height).isActive = true
    let topAnchor = toastView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: -(height))
    topAnchor.isActive = true
    view.layoutIfNeeded()
    UIView.animate(withDuration: animationDuration, animations: { [unowned self] in
      topAnchor.constant += (height + 8.0)
      self.view.layoutIfNeeded()
    }) { (_) in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        UIView.animate(withDuration: animationDuration, animations: { [unowned self] in
          topAnchor.constant -= (height + 8.0)
          self.view.layoutIfNeeded()
          }, completion: { (_) in
            toastView.removeFromSuperview()
        })
      })
    }
  }
  
  func showLoading() {
    HUD.show(.progress)
  }
  
  func hideLoading() {
    HUD.hide()
  }
  
  func showError(message: String) {
    HUD.show(.labeledError(title: "Ошибка", subtitle: message), onView: self.view)
    HUD.hide(afterDelay: 2.0)
  }
}

