//
//  DBManager.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import Foundation

import RealmSwift

class DBManager {
    
    class func saveMovie(_ movie: Movie?) {
        if let movie = movie {
            let realm = try! Realm()
            try! realm.write {
                realm.add(movie, update: true)
            }
        }
    }
    
    class func deleteMovie(_ movie: Movie?) {
        let realm = try! Realm()
        if let movie = movie, let movieToDelete = realm.object(ofType: Movie.self, forPrimaryKey: movie.movieId) {
            try! realm.write {
                realm.delete(movieToDelete)
            }
        }
    }
    
    class func loadFavoriteMovies() -> [Movie] {
        let realm = try! Realm()
        return Array(realm.objects(Movie.self))
    }
    
    class func isFavorite(_ movie: Movie?) -> Bool {
        let realm = try! Realm()
        if let movie = movie, let _ = realm.object(ofType: Movie.self, forPrimaryKey: movie.movieId) {
            return true
        } else {
            return false
        }
    }
    
}
