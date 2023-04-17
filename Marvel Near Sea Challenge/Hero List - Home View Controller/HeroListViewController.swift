//
//  HeroListViewController.swift
//  Marvel Near Sea Challenge
//
//  Created by Alex Faria on 17/04/2023.
//

import UIKit
import Foundation
import CryptoKit

class HeroListViewController: UIViewController,
                              UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UIScrollViewDelegate {
    
    // MARK: Constants
    
    enum Constants {
        
        static let appTitle: String = "Avengers, Assemble!"
        static let privateKey = "763cfff7a613b5615bcbd572644bf1171cf6efd0"
        static let publicKey = "f9adf601759986e2859278676a5af5ef"
        static let hashString: String = "1" + privateKey + publicKey
        static let data = Data(hashString.utf8)
        static let digest = Insecure.MD5.hash(data: data)
        static let hashMarvel = digest.map { String(format: "%02hhx", $0) }.joined()
        static let thumbnailType: String = ThumbnailType.standardAmazing.rawValue
        static let limit = 20
        static let url: String = "https://gateway.marvel.com:443/v1/public/characters?&orderBy=name&limit=\(limit)&apikey=\(publicKey)&hash=\(hashMarvel)&ts=1"
        static let searchPlaceholder = "Search Heroes"
        static let footerIdentifier = "Footer"
        static let urlOffset = "&offset="
        static let loadingPlaceholder = "Loading..."
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let imagePathErrorMessage = "Image path not found"
        static let imageExtensionErrorMessage = "Image extension not found"
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    let tabBar = UITabBarController()
    let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    // MARK: Variables
    
    var collectionView: UICollectionView?
    var characters: [Character] = []
    var heroImages: [UIImage?] = []
    var filteredCharacters: [Character] = []
    var filteredHeroImages: [UIImage?] = []
    var isPaginating = false
    var timer: Timer?
    var imageCache = NSCache<NSString, UIImage>()
    var isSearchBarEmpty: Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        
        return searchController.isActive && isSearchBarEmpty == false
    }
    
    var flowLayout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset.left = 20
        layout.sectionInset.right = 20
        layout.sectionInset.top = 10
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 60) / 2, //60: insets
                                 height: (UIScreen.main.bounds.height / 3) - 4)
        
        return layout
    }()
    
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //        transition.dismissCompletion = { [weak self] in
        //            guard
        //                let selectedIndexPathCell = self?.collectionView?.indexPathsForSelectedItems,
        //                let selectedCell = self?.collectionView?.cellForItem(at: selectedIndexPathCell.first!)
        //                    as? CustomCollectionViewCell
        //            else {
        //                return
        //            }
        //
        //            selectedCell.shadowView.isHidden = false
        //        }
        
        self.title = Constants.appTitle
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = Constants.searchPlaceholder
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        
        //this unwrapps collectionView because it's an optional
        guard let collectionView = self.collectionView else { return }
        
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: CustomCollectionViewCell.Constants.cellIdentifier)
        
        collectionView.register(CollectionViewFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: Constants.footerIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?
            .footerReferenceSize = CGSize(width: collectionView.bounds.width,
                                          height: 50)
        
        self.view.addSubview(collectionView)
        
        // MARK: Constraints
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.getData(from: Constants.url) //assíncrono
    }
    
    //user scrolled to the bottom of the page, show loading indicator while fetching data
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        let newURL: String = Constants.url + Constants.urlOffset + String(characters.count)
        
        if position > (self.collectionView?.contentSize.height ?? 1000) - 100 - scrollView.frame.size.height {
            
            if self.isPaginating == false {
                
                self.getData(from: newURL)
            }
        }
    }
}

// MARK: - HeroList CollectionView

extension HeroListViewController {
    
    //Adds footer for loading indicator
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: Constants.footerIdentifier,
                                                                         for: indexPath)
            footer.addSubview(self.footerView)
            self.footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            return footer
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.isFiltering {
            
            return self.filteredCharacters.count
        }
        
        return self.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let hero: Character
        let heroCharacterID: Int
        let heroDescription: String
        let heroImage: UIImage?

        if self.isFiltering {
            
            hero = self.filteredCharacters[indexPath.item]
            heroImage = self.filteredHeroImages[indexPath.item]
            
        } else {
            
            hero = self.characters[indexPath.item]
            heroImage = self.heroImages[indexPath.item]
        }
        
        heroDescription = hero.description ?? Constants.loadingPlaceholder
        heroCharacterID = hero.id ?? 0
        
        let heroDetailViewController = HeroDetailViewController(heroID: heroCharacterID,
                                                                heroDetailNameText: hero.name ?? Constants.loadingPlaceholder,
                                                                heroDetailDescriptionText: heroDescription,
                                                                heroDetailImage: heroImage)


        heroDetailViewController.modalPresentationStyle = .custom
        present(heroDetailViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //dequeue the cell from the collectionView and return it
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.Constants.cellIdentifier,
                                                          for: indexPath) as? CustomCollectionViewCell else {
                
                return CustomCollectionViewCell()
            }
        
        // MARK: Constants
        
        let heroImagesLink: String
        let heroImagesExtension: String
        let image: UIImage?
        
        // MARK: Variables
        
        var hero: Character
                
        if self.isFiltering {
            
            hero = self.filteredCharacters[indexPath.item]
            image = self.filteredHeroImages[indexPath.item]
            
        } else {
            
            hero = self.characters[indexPath.item]
            image = self.heroImages[indexPath.item]
        }
                
        cell.configure(label: hero.name ?? Constants.loadingPlaceholder)
        
        heroImagesLink = hero.thumbnail?.path ?? Constants.imagePathErrorMessage
        heroImagesExtension = hero.thumbnail?.extension ?? Constants.imageExtensionErrorMessage
        
        let completeLink: String = heroImagesLink + "/" + Constants.thumbnailType + "." + heroImagesExtension
        let imageKey: NSString = String(indexPath.item) as NSString
        
        
        //para imagens na pesquisa
        if isFiltering {
            
            //se imagem já existe
            if let image = image {
                
                cell.heroImageView.image = image
                
                //senão, fazer download
            } else {
                
                self.download(from: completeLink, index: indexPath.item) { image in
                    
                    DispatchQueue.main.async {
                                                
                        cell.heroImageView.image = image
                        
                        if self.isFiltering {
                            
                            self.filteredHeroImages[indexPath.item] = image
                            
                        } else {
                            
                            self.heroImages[indexPath.item] = image
                        }
                    }
                }
            }
            
            //imagens fora da pesquisa
        } else {
            
            //se a imagem fora da pesquisa existe em cache
            if let image = self.imageCache.object(forKey: imageKey) {
                
                cell.heroImageView.image = image
                
                //se a imagem fora da pesquisa não existe em cache
            } else {
                
                self.download(from: completeLink, index: indexPath.item) { image in
                    
                    DispatchQueue.main.async {
                        
                        self.imageCache.setObject(image, forKey: imageKey)
                        
                        cell.heroImageView.image = image
                        
                        if self.isFiltering {
                            
                            self.filteredHeroImages[indexPath.item] = image
                            
                        } else {
                            
                            self.heroImages[indexPath.item] = image
                        }
                    }
                }
            }
        }
        
        return cell
    }
}
