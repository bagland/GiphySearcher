//
//  Protocols.swift
//  GIPHY App
//
//  Created by Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//

import Foundation

protocol IndicatableView: class {
  func showNotReachableMessage()
  func showLoading()
  func hideLoading()
  func showError(message: String)
}
