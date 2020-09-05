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
import SwiftUI

class FavoritesViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case main
    }
    
    private var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, String>
    private var dataSource: DataSource!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    let podcasts = Array(Set(UserDefaults.standard.savedEpisodes().map { $0.imageUrl ?? ""}))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorite Casts"
        configureCollectionView()
        configureDataSource()
        updateSnapshot(with: podcasts.reversed())
        print("USER D EPS: \(UserDefaults.standard.savedEpisodes().count)")
        dump(podcasts)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("\(UserDefaults.standard.savedEpisodes().count)")
    }
    
    private func updateSnapshot(with episodes: [String]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(episodes)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(PodcastCell.self, forCellWithReuseIdentifier: PodcastCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let fullArtItem = NSCollectionLayoutItem(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/3)))

            fullArtItem.contentInsets = NSDirectionalEdgeInsets(top: 4,leading: 4,bottom: 4,trailing: 4)
            
            let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))

            mainItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

            // 2
            let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(0.5)))

            pairItem.contentInsets = NSDirectionalEdgeInsets(top: 4,leading: 4,bottom: 4,trailing: 4)

            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: pairItem, count: 2)

            // 1
            let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [mainItem, trailingGroup])
            
            let tripletItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))

            tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 4,leading: 4,bottom: 4,trailing: 4)

            let tripletGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitems: [tripletItem, tripletItem, tripletItem])
            
            let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItem])
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(16/9)), subitems: [fullArtItem,mainWithPairGroup,tripletGroup,mainWithPairReversedGroup])

            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            return section
        }
        
        // layout
        return layout
    }
    
    private func configureDataSource() {
        // initializing the data source and
        // configuring the cell
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, episodeArt) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodcastCell.reuseIdentifier, for: indexPath) as? PodcastCell else {
                fatalError("could not dequeue Podcast Cell")
            }
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: URL(string: episodeArt ))
//            cell.imageView.image = UIImage(named: podcast.image)
            cell.imageView.contentMode = .scaleToFill
            return cell
        })
        
        var snapshot = dataSource.snapshot() // current snapshot
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let episodeArt = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        print(episodeArt)
    }
    
    func goToEpisodesList(episode: Episode) {
//        let host = UIHostingController(rootView: EpisodesView()
    }
}
