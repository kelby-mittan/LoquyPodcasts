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
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind,String>
    private var dataSource: DataSource!
    
    private var subscriptions: Set<AnyCancellable> = []
    
//    let podcasts = Array(Set(UserDefaults.standard.savedEpisodes().map { $0.imageUrl ?? ""}))
    let heyNow = "hey$now"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorite Casts"
        configureCollectionView()
        configureDataSource()
        updateSnapshot(with: Array(Set(nonDuplicatedCasts())))
//        print("USER D EPS: \(UserDefaults.standard.savedEpisodes().count)")
//        dump(podcasts)
//        dump(getArtArray())
        dump(getAuthorArray())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("\(UserDefaults.standard.savedEpisodes().count)")
    }
    
    private func nonDuplicatedCasts() -> [String] {
        var artAndAuthors = [String]()
        var authors = [String]()
        let episodes = UserDefaults.standard.savedEpisodes()
        for episode in episodes {
            if !authors.contains(episode.author) {
                artAndAuthors.append((episode.imageUrl ?? "") + heyNow + episode.author)
                authors.append(episode.author)
            }
        }
        return artAndAuthors
    }
    
    private func getArtArray() -> [String] {
        return nonDuplicatedCasts().map { $0.components(separatedBy: heyNow)[0] }
    }
    
    private func getAuthorArray() -> [String] {
        return nonDuplicatedCasts().map { $0.components(separatedBy: heyNow)[1] }
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
            print(episodeArt)
            if episodeArt.count > 12 {
                cell.imageView.kf.setImage(with: URL(string: episodeArt.components(separatedBy: self.heyNow)[0] ))
            } else {
                cell.imageView.image = UIImage(named: episodeArt)
            }
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
        
        goToEpisodesList(episodeArt: episodeArt.components(separatedBy: heyNow)[1])
        print(episodeArt)
    }
    
    func goToEpisodesList(episodeArt: String) {
//        let host = UIHostingController(rootView: EpisodesView(title: episodeArt, podcastFeed: "", isSaved: true))
//
//        guard let hostView = host.view else { return }
//        hostView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            hostView.topAnchor.constraint(equalTo: view.topAnchor),
//            hostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            hostView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            hostView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
        let childView = UIHostingController(rootView: EpisodesView(title: episodeArt, podcastFeed: "", isSaved: true, artWork: episodeArt))
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}