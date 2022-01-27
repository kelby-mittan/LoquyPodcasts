//
//  FavoritesViewController.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/4/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftUI
import DataPersistence

class FavoritesViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case main
    }
        
    private var collectionView: UICollectionView!
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind,String>
    private var dataSource: DataSource!
    
    private var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = RepText.favCasts
        configureCollectionView()
        configureDataSource()
        updateSnapshot(with: Array(Set(nonDuplicatedCasts())))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateSnapshot(with: Array(Set(nonDuplicatedCasts())))
    }
    
    private func nonDuplicatedCasts() -> [String] {
        var artAndAuthors = [String]()
        var authors = [String]()
        do {
            episodes = try Persistence.episodes.loadItems()
        } catch {
            print(ErrorText.gettingEpisodes+error.localizedDescription)
        }
        for episode in episodes {
            if !authors.contains(episode.author) {
                artAndAuthors.append((episode.imageUrl ?? RepText.empty) + RepText.heyNow + episode.author)
                authors.append(episode.author)
            }
        }
        return artAndAuthors
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
                heightDimension: .fractionalWidth(2.2/3)))

            fullArtItem.contentInsets = NSDirectionalEdgeInsets(top: 6,leading: 6,bottom: 6,trailing: 6)
            
            let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))

            mainItem.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)

            let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(0.6)))

            pairItem.contentInsets = NSDirectionalEdgeInsets(top: 6,leading: 6,bottom: 6,trailing: 6)

            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: pairItem, count: 2)

            let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(5/9)), subitems: [mainItem, trailingGroup])
            
            let tripletItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))

            tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 6,leading: 6,bottom: 6,trailing: 6)

            let tripletGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2.5/9)), subitems: [tripletItem, tripletItem, tripletItem])
            
            let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItem])
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(14.2/9)), subitems: [fullArtItem,mainWithPairGroup,tripletGroup,mainWithPairReversedGroup])

            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, episodeArt) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodcastCell.reuseIdentifier, for: indexPath) as? PodcastCell else {
                fatalError(ErrorText.deqPodCell)
            }
            cell.imageView.kf.indicatorType = .activity
            if episodeArt.count > 12 {
                cell.imageView.kf.setImage(with: URL(string: episodeArt.components(separatedBy: RepText.heyNow)[0] ))
            } else {
                cell.imageView.image = UIImage(named: episodeArt)
            }
            cell.imageView.contentMode = .scaleToFill
            return cell
        })
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let episodeArt = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        goToEpisodesList(episodeArt: episodeArt.components(separatedBy: RepText.heyNow)[1])
    }
    
    func goToEpisodesList(episodeArt: String) {
        let childView = UIHostingController(rootView: EpisodesView(title: episodeArt, podcastFeed: RepText.empty, isSaved: true, artWork: episodeArt))
        navigationController?.pushViewController(childView, animated: true)
    }
}
