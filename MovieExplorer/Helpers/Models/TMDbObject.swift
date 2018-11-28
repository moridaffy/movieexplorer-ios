//
//  TMDbObject.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 28/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import Foundation

struct TMDbObject: Codable {
    var page: Int
    var totalPages: Int
    var totalResults: Int
    var results: [MovieShortStructure]
}

struct MovieShortStructure: Codable {
    var id: Int                 // movieId
    var title: String           // name
    var overview: String?       // desc
    var adult: Bool             // adult
    var posterPath: String?     // posterImageUrl
    var backdropPath: String?   // backdropImageUrl
    var voteAverage: Double     // vote
    var releaseDate: String     // dateValue
}

struct MovieFullStructure: Codable {
    var id: Int                 // movieId
    var title: String           // name
    var overview: String?       // desc
    var adult: Bool             // adult
    var posterPath: String?     // posterImageUrl
    var backdropPath: String?   // backdropImageUrl
    var voteAverage: Double     // vote
    var releaseDate: String     // dateValue
    var tagline: String?        // tagline
    var genres: [Genre]
    
    var genreNames: [String] {
        var output: [String] = []
        for genre in genres {
            output.append(genre.name)
        }
        return output
    }
}

struct Genre: Codable {
    var name: String
}
