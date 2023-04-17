//
//  HeroDetailViewController.swift
//  Marvel Near Sea Challenge
//
//  Created by Alex Faria on 17/04/2023.
//

import UIKit

class HeroDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Constants
    
    enum Constants {
        
        static let cellIdentifier: String = "SOME_CELL_IDENTIFIER"
        static let heart: String = "heart"
        static let heartFill: String = "heart.fill"
        static let heroDetailCellIdentifier: String = "cell"
        static let backButton: String = "xmark.circle.fill"
        static let blank: String = ""
    }
    
    let heroDetailTableView = UITableView(frame: .zero, style: .plain)
    let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    // MARK: Variables
    
    var heroDetailNameText: String = Constants.blank
    var heroDetailDescriptionText: String = Constants.blank
    var heroDetailImageContent: UIImage?
    /// [Número de Secção : [Nome da Secção : [Array de detalhes]]]
    var heroDetails = [Int : [String : [Detail]]]()
    var heroID: Int = 0
    var idOfFavoriteHeroes: [Int] = []
    
    init(heroID: Int,
         heroDetailNameText: String,
         heroDetailDescriptionText: String,
         heroDetailImage: UIImage?) {

        self.heroID = heroID
        self.heroDetailNameText = heroDetailNameText
        self.heroDetailDescriptionText = heroDetailDescriptionText
        self.heroDetailImageContent = heroDetailImage

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let urlForComics = "https://gateway.marvel.com:443/v1/public/characters/\(heroID)/comics?orderBy=title&limit=3&apikey=\(HeroListViewController.Constants.publicKey)&hash=\(HeroListViewController.Constants.hashMarvel)&ts=1"
        let urlForEvents = "https://gateway.marvel.com:443/v1/public/characters/\(heroID)/events?orderBy=name&limit=3&apikey=\(HeroListViewController.Constants.publicKey)&hash=\(HeroListViewController.Constants.hashMarvel)&ts=1"
        let urlForSeries = "https://gateway.marvel.com:443/v1/public/characters/\(heroID)/series?orderBy=title&limit=3&apikey=\(HeroListViewController.Constants.publicKey)&hash=\(HeroListViewController.Constants.hashMarvel)&ts=1"
        let urlForStories = "https://gateway.marvel.com:443/v1/public/characters/\(heroID)/stories?orderBy=id&limit=3&apikey=\(HeroListViewController.Constants.publicKey)&hash=\(HeroListViewController.Constants.hashMarvel)&ts=1"
        
        var heroDetailImage: UIImageView
        var heroDetailName: PaddingLabel
        var heroDetailDescription: PaddingLabel
        
        // MARK: Hero Image
        
        heroDetailImage = UIImageView(frame:CGRect(x: 0,
                                                   y: 0,
                                                   width: view.frame.width,
                                                   height: view.frame.height / 2));
        heroDetailImage.image = self.heroDetailImageContent
        heroDetailImage.clipsToBounds = true
        heroDetailImage.contentMode = UIImageView.ContentMode.scaleAspectFill
        
        // MARK: Hero Name
        
        heroDetailName = PaddingLabel(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: heroDetailImage.frame.width,
                                                    height: 0))
        heroDetailName.text = self.heroDetailNameText
        heroDetailName.textAlignment = .left
        heroDetailName.leftInset = 20
        heroDetailName.rightInset = 20
        heroDetailName.bottomInset = 5
        heroDetailName.topInset = 20
        heroDetailName.backgroundColor = .black.withAlphaComponent(0.6)
        heroDetailName.textColor = .white
        heroDetailName.font = UIFont.systemFont(ofSize: 30, weight: .black)
        
        // MARK: Hero Description
        
        heroDetailDescription = PaddingLabel(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: heroDetailName.frame.width,
                                                           height: 0))
        heroDetailDescription.text = self.heroDetailDescriptionText
        heroDetailDescription.textAlignment = .left
        heroDetailDescription.leftInset = 20
        heroDetailDescription.rightInset = 20
        heroDetailDescription.bottomInset = 20
        heroDetailDescription.topInset = 5
        heroDetailDescription.backgroundColor = .black.withAlphaComponent(0.6)
        heroDetailDescription.textColor = .white
        heroDetailDescription.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        heroDetailDescription.numberOfLines = 20
        heroDetailDescription.lineBreakMode = .byTruncatingTail
        
        // MARK: Hero Table View
        
        self.heroDetailTableView.register(UITableViewCell.self,
                                          forCellReuseIdentifier: Constants.heroDetailCellIdentifier)
        self.heroDetailTableView.delegate = self
        self.heroDetailTableView.dataSource = self
        self.heroDetailTableView.contentInset = UIEdgeInsets(top: 0,
                                                             left: 0,
                                                             bottom: 10,
                                                             right: 0)
        
        // MARK: Back button
        
        let backButton: UIButton = {
            
            let backButton = UIButton()
            backButton.setImage(UIImage(systemName: Constants.backButton), for: .normal)
            backButton.setTitleColor(.tintColor, for: .normal)
            backButton.imageView?.contentMode = .scaleAspectFit
            
            return backButton
        }()
        
        backButton.frame = CGRect(x: 30, y: 50, width: 20, height: 20)
        backButton.addTarget(self, action: #selector(self.dismissHeroDetail), for: .touchUpInside)

        self.view.addSubview(self.heroDetailTableView)
        self.view.addSubview(heroDetailImage)
        self.view.addSubview(heroDetailName)
        self.view.addSubview(heroDetailDescription)
        self.view.addSubview(backButton)
        
        getComicsDetailedData(from: urlForComics)
        getEventsDetailedData(from: urlForEvents)
        getSeriesDetailedData(from: urlForSeries)
        getStoriesDetailedData(from: urlForStories)
        
        // MARK: Constraints
        
        self.heroDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        heroDetailDescription.translatesAutoresizingMaskIntoConstraints = false
        heroDetailName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heroDetailTableView.topAnchor.constraint(equalTo: heroDetailImage.bottomAnchor),
            self.heroDetailTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.heroDetailTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.heroDetailTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            heroDetailName.bottomAnchor.constraint(equalTo: heroDetailDescription.topAnchor),
            heroDetailName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            heroDetailName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            heroDetailDescription.topAnchor.constraint(equalTo: heroDetailName.bottomAnchor),
            heroDetailDescription.bottomAnchor.constraint(equalTo: heroDetailImage.bottomAnchor),
            heroDetailDescription.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            heroDetailDescription.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

//MARK: Table View

extension HeroDetailViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfHeroes = self.heroDetails[section]?.values.first?.count ?? 0
        
        return numberOfHeroes
    }
    
    // MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: Constants.cellIdentifier)
        cell.selectionStyle = .none
        cell.detailTextLabel?.numberOfLines = 5
        if let sectionValues = self.heroDetails[indexPath.section],
           let sectionTitle = sectionValues.keys.first,
           let sectionElements = sectionValues[sectionTitle] {
            
            cell.textLabel?.text = sectionElements[indexPath.item].title
            
            cell.detailTextLabel?.text = sectionElements[indexPath.item].description
        }
        
        return cell
    }
    
    // MARK: Title for header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.heroDetails[section]?.keys.first ?? ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.heroDetails.keys.count
    }
}

// MARK: - Buttons
extension HeroDetailViewController {
    
    @objc func dismissHeroDetail(){

        dismiss(animated: true, completion: nil)
    }
}
