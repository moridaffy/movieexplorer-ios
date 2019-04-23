//
//  MovieDetailsViewController.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 28/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit
import RxSwift

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var backdropBlurEffectView: UIVisualEffectView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private var model: MovieDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupContent()
        setupTableView()
        setupNavigationBar()
    }
    
    func setup(model: MovieDetailsViewModel) {
        self.model = model
    }
    
    private func setupNavigationBar() {
        title = "Детали"
        
        let favoriteIcon = DBManager.isFavorite(model.movie) ? UIImage(named: "icon_heart_filled")! : UIImage(named: "icon_heart")!
        let favoriteButton = UIBarButtonItem(image: favoriteIcon, style: .done, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.register(UINib(nibName: "MovieDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: MovieDetailsTableViewCell.self))
        
        model.titleArray.asObservable()
            .bind(to: tableView.rx.items) { [unowned self](tableView, index, model) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieDetailsTableViewCell.self)) as? MovieDetailsTableViewCell else { fatalError() }
                cell.setup(model: MovieDetailsTableViewCellModel(title: self.model.titleArray.value[index], content: self.model.contentArray.value[index]))
                return cell
        }.disposed(by: disposeBag)
    }
    
    private func setupContent() {
        titleLabel.text = model.movie.name
        
        if let posterPath = model.movie.posterImageUrl {
            posterImageView.kf.setImage(with: URL(string: APIManager.URLs.imageBaseUrl + posterPath), placeholder: UIImage(named: "poster_placeholder"))
        } else {
            posterImageView.image = UIImage(named: "poster_placeholder")
        }
        
        if let backdropPath = model.movie.backdropImageUrl {
            backdropImageView.kf.setImage(with: URL(string: APIManager.URLs.imageBaseUrl + backdropPath))
        } else {
            backdropImageView.image = nil
        }
    }
    
    @objc func favoriteButtonTapped() {
        if DBManager.isFavorite(model.movie) {
            // был в избранном, убираем
            DBManager.deleteMovie(model.movie)
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icon_heart")
        } else {
            // не был в избранном, добавляем
            // создание отдельного объекта для избежания ошибки Object has been deleted or invalidated
            let newMovie = Movie(movieId: model.movie.movieId,
                                 name: model.movie.name,
                                 desc: model.movie.desc,
                                 posterImage: model.movie.posterImageUrl,
                                 backdropImage: model.movie.backdropImageUrl,
                                 adult: model.movie.adult,
                                 vote: model.movie.vote,
                                 dateValue: model.movie.dateValue,
                                 genres: Array(model.movie.genres),
                                 tagline: model.movie.tagline)
            
            DBManager.saveMovie(newMovie)
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icon_heart_filled")
        }
    }
}

extension MovieDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
