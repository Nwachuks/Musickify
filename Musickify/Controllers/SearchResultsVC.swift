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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .album(let model):
            cell.textLabel?.text = model.name
        case .artist(let model):
            cell.textLabel?.text = model.name
        case .track(let model):
            cell.textLabel?.text = model.name
        case .playlist(let model):
            cell.textLabel?.text = model.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        if let resultTapped = resultTapped {
            resultTapped(result)
        }
    }
}
