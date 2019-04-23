//
//  MovieListViewController.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Kingfisher

class MovieListViewController: UITableViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    private weak var placeholderLabel: UILabel?
    private weak var refresher: UIRefreshControl?
  
    private var model = MovieListViewModel(showingFavorite: false, movies: [])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    
    func setup(model: MovieListViewModel) {
        self.model = model
    }
    
    func setupNavigationBar() {
        if !model.showingFavorite {
            title = "Список фильмов"
            searchBar.delegate = self
            let aboutButton = UIBarButtonItem(title: "О приложении", style: .done, target: self, action: #selector(aboutButtonTapped))
            navigationItem.leftBarButtonItem = aboutButton
            
            let favoriteButton = UIBarButtonItem(title: "Избранное", style: .plain, target: self, action: #selector(favoriteButtonTapped))
            navigationItem.rightBarButtonItem = favoriteButton
        } else {
            title = "Избранное"
            tableView.tableHeaderView = nil
        }
    }
    
    func setupTableView() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(reloadMovies), for: .valueChanged)
        self.refresher = refresher
        tableView.refreshControl = self.refresher
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: MovieTableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = nil
        
        model.movies.asObservable()
            .subscribe { [weak self] (event) in
                guard let movies = event.element else { return }
                self?.setPlaceholder(show: movies.isEmpty)
        }.disposed(by: disposeBag)
        
        model.movies.asObservable()
            .bind(to: tableView.rx.items) { (tableView, index, model) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self)) as? MovieTableViewCell else { fatalError() }
                cell.setup(model: MovieTableViewCellModel(name: model.name, desc: model.desc, posterUrl: model.posterImageUrl, backdropUrl: model.backdropImageUrl))
                return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self)
            .subscribe { [weak self] (event) in
                guard let movie = event.element,
                      let vc = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else { return }
                vc.setup(model: MovieDetailsViewModel(movie: movie))
                self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    @objc func reloadMovies() {
        if !model.showingFavorite {
            view.endEditing(true)
            refresher?.beginRefreshing()
            
            if let text = searchBar.text, text.count > 0 {
                APIManager.getMovieListSearch(search: text) { [weak self] (movies, error) in
                    if let movies = movies {
                        self?.model.movies.value = movies.sorted(by: { $0.vote > $1.vote })
                        self?.doneLoading(removeFooter: false)
                    } else {
                        self?.doneLoading(removeFooter: false)
                        self?.showAlertError(error: error, desc: "Не удалось загрузить список фильмов по следующему поисковому запросу: \(text)", critical: false)
                    }
                }
            } else {
                APIManager.getMovieListPopular { [weak self] (movies, error) in
                    if let movies = movies {
                        self?.model.movies.value = movies.sorted(by: { $0.vote > $1.vote })
                        self?.doneLoading(removeFooter: false)
                    } else {
                        self?.doneLoading(removeFooter: false)
                        self?.showAlertError(error: error, desc: "Не удалось загрузить список популярных фильмов", critical: false)
                    }
                }
            }
        } else {
            model.movies.value = DBManager.loadFavoriteMovies()
            refresher?.endRefreshing()
        }
    }
    
    @objc func aboutButtonTapped() {
        let web = UIAlertAction(title: "Веб-сайт", style: .default, handler: { _ in
            let url = URL(string: "http://mskr.name")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        showAlert(title: "О приложении", body: "Разработчик: Скрябин Максим", button: "Ок", actions: [web])
    }
    
    @objc func favoriteButtonTapped() {
        let movieListViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
        
        movieListViewController.setup(model: MovieListViewModel(showingFavorite: true, movies: DBManager.loadFavoriteMovies()))
        navigationController?.pushViewController(movieListViewController, animated: true)
    }
    
    func loadMovies(at page: Int) {
        if let text = searchBar.text, !text.isEmpty {
            APIManager.getMovieListSearch(search: text, page: page) { [weak self] (newMovies, error) in
                if let newMovies = newMovies {
                    self?.model.currentPage = page
                    self?.model.movies.value.append(contentsOf: newMovies.sorted(by: { $0.vote > $1.vote }))
                    self?.doneLoading(removeFooter: true)
                } else {
                    self?.showAlertError(error: error, desc: "Не удалось загрузить дополнительные фильмы", critical: false)
                    self?.doneLoading(removeFooter: true)
                }
            }
        } else {
            APIManager.getMovieListPopular(page: page) { [weak self] (newMovies, error) in
                if let newMovies = newMovies {
                    self?.model.currentPage = page
                    self?.model.movies.value.append(contentsOf: newMovies.sorted(by: { $0.vote > $1.vote }))
                    self?.doneLoading(removeFooter: true)
                } else {
                    self?.showAlertError(error: error, desc: "Не удалось загрузить дополнительные фильмы", critical: false)
                    self?.doneLoading(removeFooter: true)
                }
            }
        }
    }
    
    func setPlaceholder(show: Bool) {
        if show {
            let label = UILabel()
            label.textColor = UIColor.darkGray
            label.font = UIFont.italicSystemFont(ofSize: 14.0)
            label.text = model.showingFavorite ? "У Вас пока что нет ни одного фильма в списке избранных" : "Введите поисковый запрос в поле выше и нажмите кнопку \"Поиск\", чтобы выполнить поиск фильмов с указанным поисковым запросом, или же просто потяните вниз эту ячейку для загрузки и отображения списка самых популярных фильмов по версии TMDb"
            label.textAlignment = .center
            label.numberOfLines = 0
            label.frame.size = CGSize(width: tableView.frame.width,
                                      height: tableView.frame.height / 2.0)
            tableView.tableFooterView = label
            placeholderLabel = label
        } else {
            placeholderLabel?.removeFromSuperview()
            placeholderLabel = nil
            tableView.tableFooterView = UIView()
        }
    }
    
    func setLoadingIndicatorForFooter(show: Bool) {
        if show {
            let indicator = UIActivityIndicatorView()
            indicator.style = .gray
            indicator.startAnimating()
            tableView.tableFooterView = indicator
        } else {
            tableView.tableFooterView = UIView()
        }
    }
    
    func doneLoading(removeFooter: Bool) {
        DispatchQueue.main.async {
            self.refresher?.endRefreshing()
            if removeFooter {
                self.setLoadingIndicatorForFooter(show: false)
            }
        }
    }
}

extension MovieListViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !model.showingFavorite, indexPath.row == model.movies.value.count - 1 {
            loadMovies(at: model.currentPage + 1)
            setLoadingIndicatorForFooter(show: true)
        }
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        reloadMovies()
    }
}
