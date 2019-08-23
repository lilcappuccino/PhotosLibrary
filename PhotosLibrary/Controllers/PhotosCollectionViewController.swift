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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
}

// MARK: - UISearchBarDelegate
extension PhotosCollectionViewController : UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
            print(searchText)
        })
    
    }
}
