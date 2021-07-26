//
//  HomeVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(settingsTapped))
        
        fetchData()
    }
    
    private func fetchData() {
        NetworkManager.instance.getRecommendedGenres { result in
            switch result {
            case .success(let data):
                let genres = data.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                    
                    NetworkManager.instance.getRecommendations(genres: seeds) { result in
                        //
                    }
                }
                break
            case .failure(let error):
                break
            }
        }
    }

    @objc func settingsTapped() {
        let vc = SettingsVC()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

