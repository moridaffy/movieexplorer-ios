//
//  APIManager.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import Foundation

import Alamofire

class APIManager {
    
    struct Keys {
        static let v3APIKey: String? = nil
        static let v4APIKey: String? = nil
    }
    
    struct URLs {
        static let apiBaseUrl: String = "https://api.themoviedb.org/3"
        static let imageBaseUrl: String = "https://image.tmdb.org/t/p/w1280"
        
        static let movie: String = "/movie"
        static let popular: String = "/popular"
        static let search: String = "/search"
        
        static let apiKey: String = "api_key=\(Keys.v3APIKey)"
        static let language: String = "language=ru"
        static let page: String = "page="
        static let query: String = "query="
    }
    
    class func getMovieDetails(movieId: Int, result: @escaping (Movie?, Error?) -> Void) {
        let urlString = URLs.apiBaseUrl + URLs.movie + "/\(movieId)" + "?" + URLs.apiKey + "&" + URLs.language
        if let url = URL(string: urlString) {
            Alamofire.request(url).responseData { (response) in
                if let data = response.data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let object = try decoder.decode(MovieFullStructure.self, from: data)
                        let movie = Movie(movieId: object.id, name: object.title, desc: object.overview, posterImage: object.posterPath, backdropImage: object.backdropPath, adult: object.adult, vote: object.voteAverage, dateValue: object.releaseDate, genres: object.genreNames, tagline: object.tagline)
                        result(movie, nil)
                    } catch let error {
                        result(nil, error)
                    }
                } else {
                    result(nil, response.error)
                }
            }
        }
    }
    
    class func getMovieListPopular(page: Int = 1, result: @escaping ([Movie]?, Error?) -> Void) {
        let urlString = URLs.apiBaseUrl + URLs.movie + URLs.popular + "?" + URLs.apiKey + "&" + URLs.language + "&" + URLs.page + "\(page)"
        if let url = URL(string: urlString) {
            Alamofire.request(url).responseData { (response) in
                if let data = response.data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let object = try decoder.decode(TMDbObject.self, from: data)
                        var movies: [Movie] = []
                        for movie in object.results {
                            movies.append(Movie(movieId: movie.id, name: movie.title, desc: movie.overview, posterImage: movie.posterPath, backdropImage: movie.backdropPath, adult: movie.adult, vote: movie.voteAverage, dateValue: movie.releaseDate, genres: nil, tagline: nil))
                        }
                        result(movies, nil)
                    } catch let error {
                        result(nil, error)
                    }
                } else {
                    print("no data")
                    result(nil, response.error)
                }
            }
        } else {
            result(nil, nil)
        }
    }
    
    class func getMovieListSearch(search: String, page: Int = 1, result: @escaping ([Movie]?, Error?) -> Void) {
        let urlString = URLs.apiBaseUrl + URLs.search + URLs.movie + "?" + URLs.apiKey + "&" + URLs.language + "&" + URLs.query + search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "&" + URLs.page + "\(page)"
        if let url = URL(string: urlString) {
            Alamofire.request(url).responseData { (response) in
                if let data = response.data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let object = try decoder.decode(TMDbObject.self, from: data)
                        var movies: [Movie] = []
                        for movie in object.results {
                            movies.append(Movie(movieId: movie.id, name: movie.title, desc: movie.overview, posterImage: movie.posterPath, backdropImage: movie.backdropPath, adult: movie.adult, vote: movie.voteAverage, dateValue: movie.releaseDate, genres: nil, tagline: nil))
                        }
                        result(movies, nil)
                    } catch let error {
                        result(nil, error)
                    }
                } else {
                    result(nil, response.error)
                }
            }
        }
    }
}
