//
//  SearchResultsVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import UIKit

class SearchResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var sections: [SearchSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultTVC.self, forCellReuseIdentifier: SearchResultTVC.identifier)
        tableView.register(SearchResultSubtitleTVC.self, forCellReuseIdentifier: SearchResultSubtitleTVC.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    public var resultTapped: ((SearchResult) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    public func update(with results: [SearchResult]) {
        var artists = [SearchResult]()
        var albums = [SearchResult]()
        var playlists = [SearchResult]()
        var tracks = [SearchResult]()

        results.forEach { searchResult in
            switch searchResult {
            case .artist:
                artists.append(searchResult)
            case .album:
                albums.append(searchResult)
            case .playlist:
                playlists.append(searchResult)
            case .track:
                tracks.append(searchResult)
            }
        }
        
        sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums)
        ]
        
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
    
    // MARK: TableViewDelegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .album(let model):
            guard let albumCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTVC.identifier, for: indexPath) as? SearchResultSubtitleTVC else { return UITableViewCell() }
            let album = SearchResultSubtitleViewCellViewModel(title: model.name, subtitle: model.artists.first?.name ?? "-", imageURL: URL(string: model.images.first?.url ?? ""))
            albumCell.configure(using: album)
            return albumCell
        case .artist(let model):
            guard let artistCell = tableView.dequeueReusableCell(withIdentifier: SearchResultTVC.identifier, for: indexPath) as? SearchResultTVC else { return UITableViewCell() }
            let artist = SearchResultViewCellViewModel(title: model.name, imageURL: URL(string: model.images.first?.url ?? ""))
            artistCell.configure(using: artist)
            return artistCell
        case .track(let model):
            guard let trackCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTVC.identifier, for: indexPath) as? SearchResultSubtitleTVC else { return UITableViewCell() }
            let track = SearchResultSubtitleViewCellViewModel(title: model.name, subtitle: model.artists.first?.name ?? "-", imageURL: URL(string: model.album.images.first?.url ?? ""))
            trackCell.configure(using: track)
            return trackCell
        case .playlist(let model):
            guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTVC.identifier, for: indexPath) as? SearchResultSubtitleTVC else { return UITableViewCell() }
            let playlist = SearchResultSubtitleViewCellViewModel(title: model.name, subtitle: model.owner.displayName, imageURL: URL(string: model.images.first?.url ?? ""))
            playlistCell.configure(using: playlist)
            return playlistCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        if let resultTapped = resultTapped {
            resultTapped(result)
        }
    }
}
