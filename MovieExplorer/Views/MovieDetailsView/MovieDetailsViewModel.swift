//
//  MovieDetailsViewModel.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 23/04/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift

class MovieDetailsViewModel {
    let movie: Movie
    let titleArray = Variable([] as [String])
    let contentArray = Variable([] as [String])
    
    init(movie: Movie) {
        self.movie = movie
        
        var titleArray: [String] = []
        var contentArray: [String] = []
        
        if let tagline = movie.tagline {
            titleArray.append("Слоган")
            contentArray.append(tagline)
        }
        if let desc = movie.desc {
            titleArray.append("Описание")
            contentArray.append(desc)
        }
        if let genre = movie.getGenresString() {
            titleArray.append("Жанры")
            contentArray.append(genre)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        titleArray.append("Дата релиза")
        contentArray.append(formatter.string(from: movie.date))
        titleArray.append("Рейтинг пользователей")
        contentArray.append("\(movie.vote) из 10.0")
        titleArray.append("Для взрослых")
        contentArray.append(movie.adult ? "Да" : "Нет")
        
        guard titleArray.count == contentArray.count else { fatalError() }
        self.titleArray.value = titleArray
        self.contentArray.value = contentArray
    }
}
