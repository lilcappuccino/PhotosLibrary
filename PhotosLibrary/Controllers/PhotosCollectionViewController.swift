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
    private var selectedImages = [UIImage]()
    // UICollectionViewDelegateFlowLayout
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private var numberOfSelectedPhotos: Int {
           return collectionView.indexPathsForSelectedItems?.count ?? 0
       }
    
    private lazy var actionBarButtonItem : UIBarButtonItem = {
       return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
    }()
    
    private lazy var addBarButtonItem : UIBarButtonItem = {
       return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        undateNavButtonsState()
        setupCollectionView()
        setupNavigationBar()
        setupSearchbar()
    }
    
    
    private func undateNavButtonsState() {
          addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
          actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
      }
    
    func refresh() {
         self.selectedImages.removeAll()
         self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
         undateNavButtonsState()
     }
     
    
// MARK: - NavigationButton action
    @objc func addButtonTapped(){
        print(#function)
    }
    
    @objc func actionButtonTapped(sender: UIBarButtonItem){
        let shareController  = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
      }
        shareController.popoverPresentationController?.barButtonItem = sender
               shareController.popoverPresentationController?.permittedArrowDirections = .any
               present(shareController, animated: true, completion: nil)
    }
    
// MARK: - setup UI
    private func setupCollectionView(){
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseId)
    }
    
    private func setupNavigationBar(){
        let titleLable = UILabel()
        titleLable.text = "photos".uppercased()
        titleLable.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLable.textColor = #colorLiteral(red: 0.4867147843, green: 0.370483599, blue: 0.4030036358, alpha: 0.5556506849)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLable)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
    
    private func setupSearchbar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
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
    
    
    // add Image to selected photo array
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           undateNavButtonsState()
           let cell = collectionView.cellForItem(at: indexPath) as! PhotosCollectionViewCell
           guard let image = cell.imageView.image else { return }
               selectedImages.append(image)
           
       }
       // remove photo from selected photo array
       override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
           undateNavButtonsState()
           let cell = collectionView.cellForItem(at: indexPath) as! PhotosCollectionViewCell
           guard let image = cell.imageView.image else { return }
           if let index = selectedImages.firstIndex(of: image) {
               selectedImages.remove(at: index)
           }
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
                self.refresh()
            }
        })
    
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = searchImages[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
