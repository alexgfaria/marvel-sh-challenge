//
//  HeroDetailViewController+APIResquest.swift
//  Marvel Near Sea Challenge
//
//  Created by Alex Faria on 17/04/2023.
//

import Foundation

extension HeroDetailViewController {

    func getComicsDetailedData(from url: String) {
        print("\(heroDetailNameText): \(self.heroID)")

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in

            //se existirem dados e error for nil, continuar. Senão, print erro
            guard let data = data, error == nil else {

                print("Something went wrong!")
                return
            }

            //have data
            let results: ComicDataWrapper?
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            var tempDetails: [Detail] = []


            do {

                results = try decoder.decode(ComicDataWrapper.self, from: data) //converts bytes to object

                if results?.data?.results?.isEmpty == false {

                    self.heroDetails[0] = ["Comics" : []]
                    self.heroDetails[0]?["Comics"] = []

                    for result in 0..<(results?.data?.results?.count ?? 0) {

                        if results?.data?.results?[result].description == nil {

                            //                        tempDetails[results?.data?.results?[result].title ?? "Loading..."] = "No description available"
                            let detail = Detail(title: results?.data?.results?[result].title ?? "Loading...",
                                                description: "")
                            tempDetails.append(contentsOf: [detail])

                        } else {

                            let detail = Detail(title: results?.data?.results?[result].title ?? "Loading...",
                                                description: results?.data?.results?[result].description ?? "Loading...")
                            tempDetails.append(contentsOf: [detail])
                        }
                    }

                    self.heroDetails[0]?["Comics"] = tempDetails

                    DispatchQueue.main.async { //reload tem de ser feito na main queue

                        self.heroDetailTableView.reloadData()
                    }
                }

            } catch {

                print(String(describing: error))
            }
        }
        task.resume()
    }

    func getEventsDetailedData(from url: String) {

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in

            //se existirem dados e error for nil, continuar. Senão, print erro
            guard let data = data, error == nil else {

                print("Something went wrong!")
                return
            }

            //have data
            let results: EventDataWrapper?
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            var tempDetails: [Detail] = []



            do {

                results = try decoder.decode(EventDataWrapper.self, from: data) //converts bytes to object

                if results?.data?.results?.isEmpty == false {

                    self.heroDetails[1] = ["Events" : []]
                    self.heroDetails[1]?["Events"] = []

                    for result in 0..<(results?.data?.results?.count ?? 0) {

                        if results?.data?.results?[result].description == nil {

                            let detail = Detail(title: results?.data?.results?[result].title ?? "Loading...",
                                                description: "")
                            tempDetails.append(contentsOf: [detail])

                        } else {

                            let detail = Detail(title: results?.data?.results?[result].title ?? "Loading...",
                                                description: results?.data?.results?[result].description ?? "Loading...")
                            tempDetails.append(contentsOf: [detail])
                        }
                    }

                    self.heroDetails[1]?["Events"] = tempDetails

                    DispatchQueue.main.async { //reload tem de ser feito na main queue

                        self.heroDetailTableView.reloadData()
                    }
                }

            } catch {

                print(String(describing: error))
            }

        }
        task.resume()
    }

    func getSeriesDetailedData(from url: String) {

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in

            //se existirem dados e error for nil, continuar. Senão, print erro
            guard let data = data, error == nil else {

                print("Something went wrong!")
                return
            }

            //have data
            let results: SeriesDataWrapper?
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            var tempDetails: [Detail] = []


            do {

                results = try decoder.decode(SeriesDataWrapper.self, from: data) //converts bytes to object

                if results?.data?.results?.isEmpty == false {

                    self.heroDetails[2] = ["Series" : []]
                    self.heroDetails[2]?["Series"] = []


                    for result in 0..<(results?.data?.results?.count ?? 0) {

                        if results?.data?.results?[result].description == nil {

                            let detail = Detail(title: results?.data?.results?[result].title ?? "Loading...",
                                                description: "")
                            tempDetails.append(contentsOf: [detail])

                        } else {

                            let detail = Detail(title: results?.data?.results?[result].title ?? "Loading...",
                                                description: results?.data?.results?[result].description ?? "Loading...")
                            tempDetails.append(contentsOf: [detail])
                        }
                    }

                    self.heroDetails[2]?["Series"] = tempDetails

                    DispatchQueue.main.async { //reload tem de ser feito na main queue

                        self.heroDetailTableView.reloadData()
                    }
                }

            } catch {

                print(String(describing: error))
            }
        }
        task.resume()
    }

    func getStoriesDetailedData(from url: String) {

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in

            //se existirem dados e error for nil, continuar. Senão, print erro
            guard let data = data, error == nil else {

                print("Something went wrong!")
                return
            }

            //have data
            let results: StoryDataWrapper?
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            var tempDetails: [Detail] = []


            do {

                results = try decoder.decode(StoryDataWrapper.self, from: data) //converts bytes to object

                if results?.data?.results?.isEmpty == false {

                    self.heroDetails[3] = ["Stories" : []]
                    self.heroDetails[3]?["Stories"] = []


                    for result in 0..<(results?.data?.results?.count ?? 0) {

                        if results?.data?.results?[result].description == nil {

                            let detail = Detail(title: results?.data?.results?[result].title ?? "Loading...",
                                                description: "")
                            tempDetails.append(contentsOf: [detail])

                        } else {

                            let detail = Detail(title: results?.data?.results?[result].title ?? "Loading...",
                                                description: results?.data?.results?[result].description ?? "Loading...")
                            tempDetails.append(contentsOf: [detail])
                        }
                    }

                    self.heroDetails[3]?["Stories"] = tempDetails

                    DispatchQueue.main.async { //reload tem de ser feito na main queue

                        self.heroDetailTableView.reloadData()
                    }
                }

            } catch {

                print(String(describing: error))
            }
        }
        task.resume()
    }
}
