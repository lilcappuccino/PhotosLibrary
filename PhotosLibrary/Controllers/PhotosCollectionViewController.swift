//
//  PhotosCollectionViewController.swift
//  PhotosLibrary
//
//  Created by dewill on 22/08/2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    private var timer : Timer?
    private let fetchImage = NetworkDataFetcher()
    private var searchImages = [UnsplashPhoto]()
    
    private lazy var actionBarButtonItem : UIBarButtonItem = {
       return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
    }()
    
    private lazy var addBarButtonItem : UIBarButtonItem = {
       return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .red
        setupCollectionView()
        setupNavigationBar()
    }
    
// MARK: - NavigationButton action
    @objc func addButtonTapped(){
        print(#function)
    }
    
    @objc func actionButtonTapped(){
          print(#function)
      }
    
// MARK: - setup UI
    private func setupCollectionView(){
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseId)
    }
    
    private func setupNavigationBar(){
        let titleLable = UILabel()
        titleLable.text = "photos".uppercased()
        titleLable.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLable.textColor = #colorLiteral(red: 0.4867147843, green: 0.370483599, blue: 0.4030036358, alpha: 0.5556506849)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLable)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    
    
    
 // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseId, for: indexPath) as! PhotosCollectionViewCell
        let currentPhoto = searchImages[indexPath.item]
        cell.unsplashPhoto = currentPhoto
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchImages.count
    }
}

// MARK: - UISearchBarDelegate
extension PhotosCollectionViewController : UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
            print(searchText)
            self.fetchImage.fetchImages(searchTerm: searchText) { [weak self] (resultImages) in
                guard let resultImages = resultImages, let self = self  else { return }
                self.searchImages = resultImages.results
                self.collectionView.reloadData()
            }
        })
    
    }
}
