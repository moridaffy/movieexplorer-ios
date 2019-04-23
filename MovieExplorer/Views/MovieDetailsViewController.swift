//
//  MovieDetailsViewController.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 28/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var backdropBlurEffectView: UIVisualEffectView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var movie: Movie!
    var titleArray: [String] = []
    var contentArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        setupContent()
    }
    
    @objc func favoriteButtonTapped() {
        if DBManager.isFavorite(movie) {
            // был в избранном, убираем
            DBManager.deleteMovie(movie)
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icon_heart")
        } else {
            // не был в избранном, добавляем
            
            // создание отдельного объекта для избежания ошибки Object has been deleted or invalidated
            let newMovie = Movie(movieId: movie.movieId, name: movie.name, desc: movie.desc, posterImage: movie.posterImageUrl, backdropImage: movie.backdropImageUrl, adult: movie.adult, vote: movie.vote, dateValue: movie.dateValue, genres: Array(movie.genres), tagline: movie.tagline)
            
            DBManager.saveMovie(newMovie)
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icon_heart_filled")
        }
    }
    
    func setupNavigationBar() {
        title = "Детали"
        
        var favoriteIcon: UIImage {
            if DBManager.isFavorite(movie) {
                return UIImage(named: "icon_heart_filled")!
            } else {
                return UIImage(named: "icon_heart")!
            }
        }
        let favoriteButton = UIBarButtonItem(image: favoriteIcon, style: .done, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailsTableViewCell")
    }
    
    func setupContent() {
        titleLabel.text = movie.name
        
        if let posterPath = movie.posterImageUrl {
            posterImageView.kf.setImage(with: URL(string: APIManager.URLs.imageBaseUrl + posterPath), placeholder: UIImage(named: "poster_placeholder"))
        } else {
            posterImageView.image = UIImage(named: "poster_placeholder")
        }
        
        if let backdropPath = movie.backdropImageUrl {
            backdropImageView.kf.setImage(with: URL(string: APIManager.URLs.imageBaseUrl + backdropPath))
        } else {
            backdropImageView.image = nil
        }
        
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
        
        titleArray.append("Рейтинг пользователей")
        contentArray.append("\(movie.vote) из 10.0")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        titleArray.append("Дата релиза")
        contentArray.append(formatter.string(from: movie.date))
        
        titleArray.append("Для взрослых")
        contentArray.append(movie.adult ? "Да" : "Нет")
    }
    
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsTableViewCell") as! MovieDetailsTableViewCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.contentLabel.text = contentArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
