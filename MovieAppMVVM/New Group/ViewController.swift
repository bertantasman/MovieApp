//
//  ViewController.swift
//  MovieApp
//
//  Created by Bertan Taşman on 21.12.2024.
//

import UIKit
import RxSwift

class AnaSayfa: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filmTable: UITableView!
    private var loadingIndicator: UIActivityIndicatorView!

    var filmler: [filmlerListe] = []
    var viewModel = filmlerDaoRepository()
    var disposeBag = DisposeBag()
    var aramaKelimesi: String? = nil

    var backGroundColor = UIColor(named: "anaRenk")

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadingIndicator()
        showLoadingIndicator()

        setupUI()
        bindViewModel()
        viewModel.filmleriYukle()
    }

    private func setupUI() {
        searchBar.delegate = self
        searchBar.backgroundColor = backGroundColor
        filmTable.dataSource = self
        filmTable.delegate = self
        filmTable.register(UINib(nibName: "cellContent", bundle: nil), forCellReuseIdentifier: "cellContent")
        filmTable.rowHeight = UITableView.automaticDimension
        filmTable.separatorColor = backGroundColor
        filmTable.allowsSelection = true
        filmTable.backgroundColor = backGroundColor
    }

    private func bindViewModel() {
        showLoadingIndicator()
        viewModel.filmlerListesi
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] liste in
                guard let self = self else { return }
                if liste.isEmpty {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                    self.filmler = liste
                    self.filmTable.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        filmTable.isHidden = true
    }

    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        filmTable.isHidden = false
    }
}

extension AnaSayfa: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmler.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let film = filmler[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContent") as! xibTableCell

        cell.filmName.text = film.Title
        cell.filmYear.text = film.Year
        cell.filmRating.text = "\(film.imdbRating ?? "N/A")"

        if let posterURL = film.Poster, let url = URL(string: posterURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.filmImage.image = UIImage(data: data)
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.filmImage.image = UIImage(named: "placeholder")
                    }
                }
            }.resume()
        } else {
            cell.filmImage.image = UIImage(named: "placeholder")
        }
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilm = filmler[indexPath.row]
        if let imdbID = selectedFilm.imdbID {
            performSegue(withIdentifier: "toDetay", sender: imdbID)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            let destinationVC = segue.destination as! filmDetayView
            if let imdbID = sender as? String {
                destinationVC.imdbID = imdbID
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if position > contentHeight - frameHeight - 100 {
            viewModel.loadMore(aramaKelimesi: aramaKelimesi)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
}

extension AnaSayfa: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            aramaKelimesi = "star"
        } else {
            aramaKelimesi = searchText
        }
        
        viewModel.ara(aramaKelimesi: aramaKelimesi ?? "star")
    }

       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
       }
}
