//
//  Movie.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import Foundation

import RealmSwift

class Movie: Object {
    
    @objc dynamic var movieId: Int = 0
    @objc dynamic var name: String!
    @objc dynamic var posterImageUrl: String?
    @objc dynamic var backdropImageUrl: String?
    
    @objc dynamic var tagline: String?
    @objc dynamic var desc: String?
    @objc dynamic var adult: Bool = false
    @objc dynamic var vote: Double = 0.0
    @objc dynamic var dateValue: String!
    @objc dynamic var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateValue) ?? Date()
    }
    
    var genres = List<String>()
    
    convenience init(movieId: Int, name: String, desc: String?, posterImage: String?, backdropImage: String?, adult: Bool?, vote: Double?, dateValue: String, genres: [String]?, tagline: String?) {
        self.init()
        
        self.movieId = movieId
        self.name = name
        self.desc = desc
        self.posterImageUrl = posterImage
        self.backdropImageUrl = backdropImage
        self.adult = adult ?? false
        self.vote = vote ?? 0.0
        self.dateValue = dateValue
        self.tagline = tagline
        
        for genre in (genres ?? []) {
            self.genres.append(genre)
        }
    }
    
    func getGenresString() -> String? {
        if genres.count == 0 {
            return nil
        } else if genres.count == 1 {
            return genres.first
        } else {
            var output: String = genres.first!
            for i in 1...(genres.count - 1) {
                output += ", \(genres[i])"
            }
            return output
        }
    }
    
    override static func primaryKey() -> String? {
        return "movieId"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["date"]
    }
    
}
