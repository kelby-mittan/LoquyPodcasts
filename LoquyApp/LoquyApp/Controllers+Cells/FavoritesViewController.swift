//
//  FavoritesViewController.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/4/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

class FavoritesViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case main
    }
    
    private var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, DummyPodcast>
    private var dataSource: DataSource!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorite Casts"
        configureCollectionView()
        configureDataSource()
        updateSnapshot(with: DummyPodcast.podcasts)
    }
    
    private func updateSnapshot(with podcasts: [DummyPodcast]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(podcasts)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(PodcastCell.self, forCellWithReuseIdentifier: PodcastCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            // item
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            let itemSpacing: CGFloat = 5 // points
//            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
//
//            // group (leadingGroup, trailingGroup, nestedGroup)
//            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50), heightDimension: .fractionalHeight(1.0))
//
//            let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 6)
//
//            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 4)
//
//            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1000))
//
//            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [leadingGroup, trailingGroup])
            
            // section
//            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            
            let fullArtItem = NSCollectionLayoutItem(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/3)))

            fullArtItem.contentInsets = NSDirectionalEdgeInsets(
              top: 2,
              leading: 2,
              bottom: 2,
              trailing: 2)
            
            let mainItem = NSCollectionLayoutItem(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1.0)))

            mainItem.contentInsets = NSDirectionalEdgeInsets(
              top: 2,
              leading: 2,
              bottom: 2,
              trailing: 2)

            // 2
            let pairItem = NSCollectionLayoutItem(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)))

            pairItem.contentInsets = NSDirectionalEdgeInsets(
              top: 2,
              leading: 2,
              bottom: 2,
              trailing: 2)

            let trailingGroup = NSCollectionLayoutGroup.vertical(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)),
              subitem: pairItem,
              count: 2)

            // 1
            let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(4/9)),
              subitems: [mainItem, trailingGroup])
            
            let tripletItem = NSCollectionLayoutItem(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)))

            tripletItem.contentInsets = NSDirectionalEdgeInsets(
              top: 2,
              leading: 2,
              bottom: 2,
              trailing: 2)

            let tripletGroup = NSCollectionLayoutGroup.horizontal(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/9)),
              subitems: [tripletItem, tripletItem, tripletItem])
            
            let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .fractionalWidth(4/9)),
            subitems: [trailingGroup, mainItem])
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(16/9)),
              subitems: [
                fullArtItem,
                mainWithPairGroup,
                tripletGroup,
                mainWithPairReversedGroup
              ]
            )

            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            return section
        }
        
        // layout
        return layout
    }
    
    private func configureDataSource() {
        // initializing the data source and
        // configuring the cell
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, podcast) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodcastCell.reuseIdentifier, for: indexPath) as? PodcastCell else {
                fatalError("could not dequeue Podcast Cell")
            }
//            cell.imageView.kf.indicatorType = .activity
//            cell.imageView.kf.setImage(with: URL(string: podcast.artworkUrl600 ?? ""))
            cell.imageView.image = UIImage(named: podcast.image)
            cell.imageView.contentMode = .scaleAspectFill
            return cell
        })
        
        // setup initial snapshot
        var snapshot = dataSource.snapshot() // current snapshot
        snapshot.appendSections([.main])
        //snapshot.appendItems(Array(1...4))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
