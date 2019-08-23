//
//  PhotosCollectionViewCell.swift
//  PhotosLibrary
//
//  Created by dewill on 23/08/2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit
import SDWebImage


class PhotosCollectionViewCell : UICollectionViewCell {
    
    static let reuseId = "PhotosCollectionViewCell"
    
    var imageView : UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var markImageView : UIImageView = {
        let image = UIImage(named: "mark")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupMarkImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    
    
    private func updateSelectedState(){
           imageView.alpha = isSelected ? 0.7 : 1
           markImageView.isHidden = !isSelected
        
    }
    
    //MARK: - Setup UI elements
    
    private func setupImageView(){
        addSubview(imageView)
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func setupMarkImageView(){
        addSubview(markImageView)
        markImageView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8 ).isActive = true
        markImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8).isActive = true
    }
    
    
    
}
