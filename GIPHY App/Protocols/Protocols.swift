//
//  Protocols.swift
//  GIPHY App
//
//  Created by Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//

import Foundation

protocol IndicatableView: class {
//  func showActivityIndicator()
//  func showError(with message: String)
//  func showNetworkError()
//  func hideActivityIndicator()
//  func hideActivityIndicatorWith(completion: @escaping() -> Void)
//  func showMessage(_ message: String)
  func showNotReachableMessage(tryAgainCompletion: @escaping(() -> Void))
}
