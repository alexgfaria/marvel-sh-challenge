//
//  APIModel.swift
//  Marvel Near Sea Challenge
//
//  Created by Alex Faria on 17/04/2023.
//

import Foundation

struct CharacterDataWrapper: Codable {
    
    let data: CharacterDataContainer?
}

struct CharacterDataContainer: Codable {
    
    let results: [Character]?
}

struct Character: Codable {
    
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Image?
    let comics: ComicList?
    let stories: StoryList?
    let events: EventList?
    let series: SeriesList?
    
    var isFavorite: Bool?
}

struct URLs: Codable {
    
    let type: String?
    let url: String?
}

struct Image: Codable {
    
    let path: String?
    let `extension`: String?
}

struct ComicList: Codable {
    
    let items: [ComicSummary]?
}

struct ComicSummary: Codable {
    
    let name: String?
}

struct StoryList: Codable {
    
    let items: [StorySummary]?
}

struct StorySummary: Codable {
    
    let name: String?
    let type: String?
}

struct EventList: Codable {
    
    let items: [EventSummary]?
}

struct EventSummary: Codable {
    
    let name: String?
}

struct SeriesList: Codable {
    
    let items: [SeriesSummary]?
}

struct SeriesSummary: Codable {
    
    let name: String?
}

// MARK: Comics
struct ComicDataWrapper: Codable {
    
    let data: ComicDataContainer?
}

struct ComicDataContainer: Codable {
    
    let results: [Comic]?
}

struct Comic: Codable {
    
    let title: String?
    let description: String?
}

// MARK: Events
struct EventDataWrapper: Codable {
    
    let data: EventDataContainer?
}

struct EventDataContainer: Codable {
    
    let results: [Event]?
}

struct Event: Codable {
    
    let title: String?
    let description: String?
}

struct SeriesDataWrapper: Codable {
    
    let data: SeriesDataContainer?
}

struct SeriesDataContainer: Codable {
    
    let results: [Series]?
}

struct Series: Codable {
    
    let title: String?
    let description: String?
}

// MARK: Stories
struct StoryDataWrapper: Codable {
    
    let data: StoryDataContainer?
}

struct StoryDataContainer: Codable {
    
    let results: [Story]?
}

struct Story: Codable {
    
    let title: String?
    let description: String?
}

struct Detail {
    
    let title: String
    let description: String
}

// MARK: Thumbnail types
enum ThumbnailType: String {
    
    case portraitSmall = "portrait_small"
    case portraitMedium = "portrait_medium"
    case portraitXLarge = "portrait_xlarge"
    case portraitFantastic = "portrait_fantastic"
    case portraitUncanny = "portrait_uncanny"
    case portraitIncredible = "portrait_incredible"
    
    case standardSmall = "standard_small"
    case standardMedium = "standard_medium"
    case standardLarge = "standard_large"
    case standardXLarge = "standard_xlarge"
    case standardFantastic = "standard_fantastic"
    case standardAmazing = "standard_amazing"
    
    case landscapeSmall = "landscape_small"
    case landscapeMedium = "landscape_medium"
    case landscapeLarge = "landscape_large"
    case landscapeXLarge = "landscape_xlarge"
    case landscapeAmazing = "landscape_amazing"
    case landscapeIncredible = "landscape_incredible"
    
    case detail = "detail"
    case fullSizeImage = "full-size image"
}
