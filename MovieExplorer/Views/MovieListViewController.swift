//
//  MovieListViewController.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

import SDWebImage

class MovieListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var refresher: UIRefreshControl?
    
    var movies: [Movie] = []
    var showingFavorite: Bool = false
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
    }
    
    @objc func reloadMovies() {
        if !showingFavorite {
            view.endEditing(true)
            refresher?.beginRefreshing()
            
            if let text = searchBar.text, text.count > 0 {
                APIManager.getMovieListSearch(search: text) { [weak self] (movies, error) in
                    if let movies = movies {
                        self?.movies = movies.sorted(by: { $0.vote > $1.vote })
                        self?.doneLoading(reload: true, removeFooter: false)
                    } else {
                        self?.doneLoading(reload: false, removeFooter: false)
                        self?.showAlertError(error: error, desc: "Не удалось загрузить список фильмов по следующему поисковому запросу: \(text)", critical: false)
                    }
                }
            } else {
                APIManager.getMovieListPopular { [weak self] (movies, error) in
                    if let movies = movies {
                        self?.movies = movies.sorted(by: { $0.vote > $1.vote })
                        self?.doneLoading(reload: true, removeFooter: false)
                    } else {
                        self?.doneLoading(reload: false, removeFooter: false)
                        self?.showAlertError(error: error, desc: "Не удалось загрузить список популярных фильмов", critical: false)
                    }
                }
            }
        } else {
            movies = DBManager.loadFavoriteMovies()
            tableView.reloadData()
            refresher?.endRefreshing()
        }
    }
    
    @objc func aboutButtonTapped() {
        let web = UIAlertAction(title: "Веб-сайт", style: .default, handler: { _ in
            let url = URL(string: "http://mskr.name")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        showAlert(title: "О приложении", body: "Приложение было создано в кач-ве демонстрации кода компании KTS.\n\nРазработчик: Скрябин Максим", button: "Ок", actions: [web])
    }
    
    @objc func favoriteButtonTapped() {
        let movieListViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
        movieListViewController.movies = DBManager.loadFavoriteMovies()
        movieListViewController.showingFavorite = true
        navigationController?.pushViewController(movieListViewController, animated: true)
    }
    
    func loadMovies(at page: Int) {
        if let text = searchBar.text, text.count > 0 {
            APIManager.getMovieListSearch(search: text, page: page) { [weak self] (newMovies, error) in
                if let newMovies = newMovies {
                    self?.currentPage = page
                    self?.movies += newMovies.sorted(by: { $0.vote > $1.vote })
                    self?.doneLoading(reload: true, removeFooter: true)
                } else {
                    self?.showAlertError(error: error, desc: "Не удалось загрузить дополнительные фильмы", critical: false)
                    self?.doneLoading(reload: false, removeFooter: true)
                }
            }
        } else {
            APIManager.getMovieListPopular(page: page) { [weak self] (newMovies, error) in
                if let newMovies = newMovies {
                    self?.currentPage = page
                    self?.movies += newMovies.sorted(by: { $0.vote > $1.vote })
                    self?.doneLoading(reload: true, removeFooter: true)
                } else {
                    self?.showAlertError(error: error, desc: "Не удалось загрузить дополнительные фильмы", critical: false)
                    self?.doneLoading(reload: false, removeFooter: true)
                }
            }
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
    
    func doneLoading(reload: Bool, removeFooter: Bool) {
        DispatchQueue.main.async {
            self.refresher?.endRefreshing()
            if reload {
                self.tableView.reloadData()
            }
            if removeFooter {
                self.setLoadingIndicatorForFooter(show: false)
            }
        }
    }
    
    func setupNavigationBar() {
        if !showingFavorite {
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
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "PlaceholderTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceholderTableViewCell")
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }
    
}

extension MovieListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies.count == 0 {
            return 1
        } else {
            return movies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if movies.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceholderTableViewCell") as! PlaceholderTableViewCell
            
            var placeholderText: String {
                if showingFavorite {
                    return "У Вас пока что нет ни одного фильма в списке избранных"
                } else {
                    return "Введите поисковый запрос в поле выше и нажмите кнопку \"Поиск\", чтобы выполнить поиск фильмов с указанным поисковым запросом, или же просто потяните вниз эту ячейку для загрузки и отображения списка самых популярных фильмов по версии TMDb"
                }
            }
            cell.titleLabel.text = placeholderText
            
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
            
            cell.nameLabel.text = movies[indexPath.row].name
            cell.descLabel.text = movies[indexPath.row].desc
            
            if let posterPath = movies[indexPath.row].posterImageUrl {
                cell.posterImageView.sd_setImage(with: URL(string: APIManager.URLs.imageBaseUrl + posterPath), placeholderImage: UIImage(named: "poster_placeholder"))
            } else {
                cell.posterImageView.image = UIImage(named: "poster_placeholder")
            }
            
            if let backdropPath = movies[indexPath.row].backdropImageUrl {
                cell.backdropImageView.sd_setImage(with: URL(string: APIManager.URLs.imageBaseUrl + backdropPath), placeholderImage: nil)
            } else {
                cell.backdropImageView.image = nil
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if movies.count != 0 {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.isSelected = false
            
            if showingFavorite {
                let movieDetailsViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
                movieDetailsViewController.movie = movies[indexPath.row]
                navigationController?.pushViewController(movieDetailsViewController, animated: true)
            } else {
                APIManager.getMovieDetails(movieId: movies[indexPath.row].movieId) { [weak self] (movie, error) in
                    if let movie = movie {
                        let movieDetailsViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
                        movieDetailsViewController.movie = movie
                        self?.navigationController?.pushViewController(movieDetailsViewController, animated: true)
                    } else {
                        self?.showAlertError(error: error, desc: "Не удалось загрузить детальную информацию о фильме", critical: false)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !showingFavorite, indexPath.row == movies.count - 1 {
            loadMovies(at: currentPage + 1)
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
