//
//  MovieListViewModel.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 23/04/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift

class MovieListViewModel {
    let movies = Variable([] as [Movie])
    let showingFavorite: Bool
    var currentPage: Int = 1
    
    init(showingFavorite: Bool = false, movies: [Movie] = []) {
        self.showingFavorite = showingFavorite
        self.movies.value = movies
    }
}
