//
//  PlaylistVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import UIKit

class PlaylistVC: UIViewController {
    
    var playlist: Playlist?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        guard let playlist = playlist else { return }
        title = playlist.name
        
        NetworkManager.instance.getPlaylistDetails(using: playlist.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }

}
