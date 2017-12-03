//
//  HomeViewController.swift
//  GIPHY App
//
//  Created Baglan on 12/3/17.
//  Copyright © 2017 Baglan. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SwiftGifOrigin

class HomeViewController: UIViewController, UISearchBarDelegate, HomeViewProtocol {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var emptyView: UIView!
  
  var presenter: HomePresenterProtocol?
  
  let cellIdentifier = "HomeCell"
  private let searchBar = UISearchBar()
  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  fileprivate var presentationItems = [CellPresentation]() {
    didSet {
      collectionView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initViews()
    presenter?.bindSearchBar(searchBar)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    dismissKeyboard()
  }
  
  @objc private func dismissKeyboard() {
    searchBar.resignFirstResponder()
  }
  
  private func initViews() {
    searchBar.placeholder = "Введите слово"
    searchBar.autocapitalizationType = .none
    searchBar.delegate = self
    navigationItem.titleView = searchBar
    configureIndicator()
    configureCollectionView()
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    emptyView.addGestureRecognizer(tap)
    emptyView.isUserInteractionEnabled = true
  }
  
  private func configureIndicator() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    searchBar.addSubview(activityIndicator)
    activityIndicator.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -44.0).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
  }
  
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    collectionView.contentInset = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)
    collectionView.keyboardDismissMode = .onDrag
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    flowLayout.invalidateLayout()
  }
  
  // MARK: - HomeViewProtocol
  func updateWithItems(_ items: [CellPresentation]) {
    self.presentationItems = items
    activityIndicator.stopAnimating()
  }
  
  func setLoadingState() {
    emptyView.isHidden = true
    activityIndicator.startAnimating()
  }
  
  func setInitialState() {
    self.presentationItems.removeAll()
    collectionView.reloadData()
    emptyView.isHidden = false
    resultLabel.text = Constants.startSearching
  }
  
  func setNothingFoundState() {
    emptyView.isHidden = false
    resultLabel.text = Constants.nothingFound
  }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let fullWidth = view.frame.width
    let spacing: CGFloat = 1.0
    return CGSize(
      width: fullWidth / 3.0 - 2 * spacing,
      height: fullWidth / 3.0 - 2 * spacing
    )
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presentationItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeCell
    let item = presentationItems[indexPath.row]
    cell.cellPresentation = item
    cell.updateViews()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    searchBar.resignFirstResponder()
    presenter?.selectedGiphyAt(index: indexPath.row)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height {
      debugPrint("Need to load more?")
    }
  }
  
}
