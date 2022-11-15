//
//  AlbumVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 14/11/2022.
//

import UIKit

class AlbumVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PlaylistHeaderCRVDelegate {
    
    var album: Album?
    private var viewModels = [AlbumTrackViewModel]()
    
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
        guard let album = album else { return }
        title = album.name
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AlbumTrackCVC.self, forCellWithReuseIdentifier: AlbumTrackCVC.identifier)
        collectionView.register(PlaylistHeaderCRV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCRV.identifier)
        view.addSubview(collectionView)
        
        NetworkManager.instance.getAlbumDetails(using: album.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.viewModels = details.tracks.items.compactMap({
                        AlbumTrackViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "-")
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: CollectionView Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCVC.identifier, for: indexPath) as? AlbumTrackCVC else { return UICollectionViewCell() }
        let playlist = viewModels[indexPath.row]
        cell.configure(with: playlist)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCRV.identifier, for: indexPath) as? PlaylistHeaderCRV, let album = album else { return UICollectionReusableView() }
        
        let headerViewModel = PlaylistHeaderViewModel(name: album.name, ownerName: album.artists.first?.name ?? "-", description: "Release date: \(String.formatDate(string: album.releaseDate))", artworkURL: URL(string: album.images.first?.url ?? ""))
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
