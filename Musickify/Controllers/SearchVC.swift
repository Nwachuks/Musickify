//
//  SearchVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import UIKit

class SearchVC: UIViewController, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: SearchResultsVC())
        searchVC.searchBar.placeholder = "Songs, Artists, Albums"
        searchVC.searchBar.searchBarStyle = .minimal
        searchVC.definesPresentationContext = true
        return searchVC
    }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150)), subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return NSCollectionLayoutSection(group: group)
    }))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Search"
        view.backgroundColor = .systemBackground
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        view.addSubview(collectionView)
        collectionView.register(GenreCVC.self, forCellWithReuseIdentifier: GenreCVC.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: Search Controller Results Delegate method
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchResultsVC,  let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        print(query)
        
    }
    
    // MARK: CollectionView Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCVC.identifier, for: indexPath) as? GenreCVC else { return UICollectionViewCell() }
        cell.configure(using: "Rock")
        return cell
    }
}
