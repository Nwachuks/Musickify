//
//  AlbumVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 14/11/2022.
//

import UIKit

class AlbumVC: UIViewController {
    
    var album: Album?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        guard let album = album else { return }
        title = album.name
        
        NetworkManager.instance.getAlbumDetails(using: album.id) { result in
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
