//
//  PodcastCell.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/4/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class PodcastCell: UICollectionViewCell {
    static let reuseIdentifier = "podcastCell"
    
    public lazy var imageView: UIImageView = {
      let iv = UIImageView()
      iv.image = UIImage(systemName: "photo")
      iv.layer.cornerRadius = 8
      iv.clipsToBounds = true
      return iv
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      commonInit()
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
      commonInit()
    }
    
    private func commonInit() {
      imageViewConstraints()
    }
    
    private func imageViewConstraints() {
      addSubview(imageView)
      imageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: topAnchor),
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      ])
    }
}
