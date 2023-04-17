//
//  HeroListViewController+Search.swift
//  Marvel Near Sea Challenge
//
//  Created by Alex Faria on 17/04/2023.
//

import Foundation
import UIKit

extension HeroListViewController: UISearchResultsUpdating {
    
    @objc func updateSearchResults(for searchController: UISearchController) {
        
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            
            let searchBar = searchController.searchBar
            let heroName: String = searchBar.text ?? ""
            let urlSearch: String = "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(heroName)&orderBy=name&limit=\(Constants.limit)&apikey=\(Constants.publicKey)&hash=\(Constants.hashMarvel)&ts=1"
            
            self.getDataFromSearch(from: urlSearch)
        }
    }
    
    func getDataFromSearch(from url: String) {
        
        self.isPaginating = true
        self.footerView.startAnimating()
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
            guard let data = data, error == nil else {
                
                print("Something went wrong!")
                return
            }
            
            //have data
            let results: CharacterDataWrapper?
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                
                results = try decoder.decode(CharacterDataWrapper.self, from: data) //converts bytes to object
                
                self.filteredCharacters = results?.data?.results ?? []
                let newArray: [UIImage?] = Array(repeating: nil, count: Constants.limit) //guardar espaço para novas imagens
                self.filteredHeroImages = newArray
                
                DispatchQueue.main.async() { //reload tem de ser feito na main queue
                    
                    self.collectionView?.reloadData()
                    self.footerView.stopAnimating()
                }
                
            } catch {
                
                print(String(describing: error))
            }
            self.isPaginating = false
        }
        task.resume()
    }
}
