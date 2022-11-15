//
//  PlaylistVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import UIKit

class PlaylistVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PlaylistHeaderCRVDelegate {
    
    var playlist: Playlist?
    
    private var viewModels = [RecommendedTrackCellViewModel]()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        // Group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            ),
            subitem: item,
            count: 1
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        guard let playlist = playlist else { return }
        title = playlist.name
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RecommendedTrackCVC.self, forCellWithReuseIdentifier: RecommendedTrackCVC.identifier)
        collectionView.register(PlaylistHeaderCRV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCRV.identifier)
        view.addSubview(collectionView)
        
        NetworkManager.instance.getPlaylistDetails(using: playlist.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellViewModel(name: $0.track.name, artworkURL: URL(string: $0.track.album.images.first?.url ?? ""), artistName: $0.track.artists.first?.name ?? "-")
                    })
                    self?.collectionView.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc private func shareTapped() {
        guard let playlist = playlist, let url = URL(string: playlist.externalURLs["spotify"] ?? "") else { return }
        let nextVC = UIActivityViewController(activityItems: [url], applicationActivities: [])
        nextVC.popoverPresentationController?.sourceView = self.view
        present(nextVC, animated: true)
    }
    
    // MARK: CollectionView Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCVC.identifier, for: indexPath) as? RecommendedTrackCVC else { return UICollectionViewCell() }
        let playlist = viewModels[indexPath.row]
        cell.configure(with: playlist)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCRV.identifier, for: indexPath) as? PlaylistHeaderCRV, let playlist = playlist else { return UICollectionReusableView() }
        
        let headerViewModel = PlaylistHeaderViewModel(name: playlist.name, ownerName: playlist.owner.displayName, description: playlist.description, artworkURL: URL(string: playlist.images.first?.url ?? ""))
        header.configure(using: headerViewModel)
        header.playlistHeaderCRVDelegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: PlaylistHeaderCRVDelegate method
    func playlistHeaderCRVPlayAllBtnTapped(_ header: PlaylistHeaderCRV) {
        print("Play all")
    }
}
