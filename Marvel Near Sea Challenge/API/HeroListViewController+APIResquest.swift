//
//  HeroListViewController+APIResquest.swift
//  Marvel Near Sea Challenge
//
//  Created by Alex Faria on 17/04/2023.
//

import Foundation
import UIKit

extension HeroListViewController {
    
    func getData(from url: String) {
        
        guard let url = URL(string: url) else { return }
        
        self.isPaginating = true
        self.footerView.startAnimating()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            //se existirem dados e error for nil, continuar. Senão, print erro
            guard let data = data,
                  error == nil else {
                      
                      print("Something went wrong!")
                      return
                  }
            
            //have data
            let results: CharacterDataWrapper?
            let decoder = JSONDecoder()
            
            do {
                
                results = try decoder.decode(CharacterDataWrapper.self, from: data) //converts bytes to object
                
                self.characters.append(contentsOf: results?.data?.results ?? [])
                
                //image
                let newArray: [UIImage?] = Array(repeating: nil, count: results?.data?.results?.count ?? 0) //guardar espaço para novas imagens
                self.heroImages.append(contentsOf: newArray)
                
                DispatchQueue.main.async { //reload tem de ser feito na main queue
                    
                    self.collectionView?.reloadData()
                    self.footerView.stopAnimating()
                    self.isPaginating = false
                }
                
            } catch {
                
                print(String(describing: error))
            }
        }
        task.resume()
    }
}

// MARK: Extensions
//extension from https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
extension HeroListViewController {
    
    func download(from url: String, index: Int, completion: @escaping (UIImage) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            completion(image)
        }.resume()
    }
}

