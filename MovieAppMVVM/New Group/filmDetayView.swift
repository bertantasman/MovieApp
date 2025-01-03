//
//  filmDetayView.swift
//  MovieApp
//
//  Created by Bertan Taşman on 21.12.2024.
//

import UIKit

class filmDetayView: UIViewController {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var part4View: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var part3View: UIView!
    @IBOutlet weak var part2View: UIView!
    @IBOutlet weak var filmDetayAciklama: UILabel!
    @IBOutlet weak var filmDetayTitle: UILabel!
    @IBOutlet weak var filmDetayImage: UIImageView!
    @IBOutlet weak var part1View: UIView!
    @IBOutlet weak var genelScrollView: UIScrollView!
    @IBOutlet weak var detaylarLabel: UILabel!
    @IBOutlet weak var filmActorsLabel: UILabel!
    private var loadingIndicator: UIActivityIndicatorView!
    
    var filmDetaylari: detaylarListe?
    var backGroundColor = UIColor(named: "anaRenk")
    var viewColor = UIColor(named: "tableRenk")
    var imdbID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Film Detayları"
        
        part2View.isHidden = true
        part3View.isHidden = true
        part4View.isHidden = true

        if let imdbID = imdbID {
            fetchFilmDetails(imdbID: imdbID)
        }
        
        setupCustomBackButton()
        setupUI()
        setupConstraints()
    }



    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .systemBlue
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        genelScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genelScrollView)
        
        part1View.translatesAutoresizingMaskIntoConstraints = false
        part1View.backgroundColor = backGroundColor
        genelScrollView.addSubview(part1View)
        genelScrollView.backgroundColor = backGroundColor
        
        filmDetayImage.translatesAutoresizingMaskIntoConstraints = false
        filmDetayImage.contentMode = .scaleAspectFit
        part1View.addSubview(filmDetayImage)
        
        part4View.translatesAutoresizingMaskIntoConstraints = false
        part4View.layer.cornerRadius = 10
        part4View.layer.masksToBounds = true
        part1View.addSubview(part4View)
        
        filmDetayTitle.translatesAutoresizingMaskIntoConstraints = false
        filmDetayTitle.font = UIFont.boldSystemFont(ofSize: 24)
        filmDetayTitle.textAlignment = .center
        filmDetayTitle.numberOfLines = 0
        part4View.addSubview(filmDetayTitle)
        
        filmDetayAciklama.translatesAutoresizingMaskIntoConstraints = false
        filmDetayAciklama.font = UIFont.systemFont(ofSize: 16)
        filmDetayAciklama.numberOfLines = 0
        part4View.addSubview(filmDetayAciklama)
        
        part2View.translatesAutoresizingMaskIntoConstraints = false
        part2View.layer.cornerRadius = 10
        part2View.layer.masksToBounds = true
        part1View.addSubview(part2View)
        
        filmActorsLabel.translatesAutoresizingMaskIntoConstraints = false
        filmActorsLabel.numberOfLines = 0
        filmActorsLabel.font = UIFont.systemFont(ofSize: 16)
        part2View.addSubview(filmActorsLabel)
        
        part3View.translatesAutoresizingMaskIntoConstraints = false
        part3View.layer.cornerRadius = 10
        part3View.layer.masksToBounds = true
        part1View.addSubview(part3View)
        
        detaylarLabel.translatesAutoresizingMaskIntoConstraints = false
        detaylarLabel.numberOfLines = 0
        detaylarLabel.font = UIFont.systemFont(ofSize: 16)
        part3View.addSubview(detaylarLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            genelScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            genelScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            genelScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genelScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            part1View.topAnchor.constraint(equalTo: genelScrollView.topAnchor),
            part1View.leadingAnchor.constraint(equalTo: genelScrollView.leadingAnchor),
            part1View.trailingAnchor.constraint(equalTo: genelScrollView.trailingAnchor),
            part1View.bottomAnchor.constraint(equalTo: genelScrollView.bottomAnchor),
            part1View.widthAnchor.constraint(equalTo: genelScrollView.widthAnchor),
            
            filmDetayImage.topAnchor.constraint(equalTo: part1View.topAnchor, constant: 10),
            filmDetayImage.centerXAnchor.constraint(equalTo: part1View.centerXAnchor),
            
            part4View.topAnchor.constraint(equalTo: filmDetayImage.bottomAnchor, constant: -5),
            part4View.leadingAnchor.constraint(equalTo: part1View.leadingAnchor, constant: 10),
            part4View.trailingAnchor.constraint(equalTo: part1View.trailingAnchor, constant: -10),
            
            filmDetayTitle.topAnchor.constraint(equalTo: part4View.topAnchor, constant: 10),
            filmDetayTitle.leadingAnchor.constraint(equalTo: part4View.leadingAnchor, constant: 10),
            filmDetayTitle.trailingAnchor.constraint(equalTo: part4View.trailingAnchor, constant: -10),
            
            filmDetayAciklama.topAnchor.constraint(equalTo: filmDetayTitle.bottomAnchor, constant: 10),
            filmDetayAciklama.leadingAnchor.constraint(equalTo: part4View.leadingAnchor, constant: 10),
            filmDetayAciklama.trailingAnchor.constraint(equalTo: part4View.trailingAnchor, constant: -10),
            filmDetayAciklama.bottomAnchor.constraint(equalTo: part4View.bottomAnchor, constant: -10),
            
            part2View.topAnchor.constraint(equalTo: part4View.bottomAnchor, constant: 10),
            part2View.leadingAnchor.constraint(equalTo: part1View.leadingAnchor, constant: 10),
            part2View.trailingAnchor.constraint(equalTo: part1View.trailingAnchor, constant: -10),
            
            filmActorsLabel.topAnchor.constraint(equalTo: part2View.topAnchor, constant: 10),
            filmActorsLabel.bottomAnchor.constraint(equalTo: part2View.bottomAnchor, constant: -10),
            filmActorsLabel.leadingAnchor.constraint(equalTo: part2View.leadingAnchor, constant: 10),
            filmActorsLabel.trailingAnchor.constraint(equalTo: part2View.trailingAnchor, constant: -10),
            
            part3View.topAnchor.constraint(equalTo: part2View.bottomAnchor, constant: 10),
            part3View.leadingAnchor.constraint(equalTo: part1View.leadingAnchor, constant: 10),
            part3View.trailingAnchor.constraint(equalTo: part1View.trailingAnchor, constant: -10),
            part3View.bottomAnchor.constraint(equalTo: part1View.bottomAnchor, constant: -10),
            
            detaylarLabel.topAnchor.constraint(equalTo: part3View.topAnchor, constant: 10),
            detaylarLabel.bottomAnchor.constraint(equalTo: part3View.bottomAnchor, constant: -10),
            detaylarLabel.leadingAnchor.constraint(equalTo: part3View.leadingAnchor, constant: 10),
            detaylarLabel.trailingAnchor.constraint(equalTo: part3View.trailingAnchor, constant: -10)
        ])
    }
    
    private func displayContent() {
        guard let filmDetaylari = filmDetaylari else { return }
        var detayMetni = """
        Year: \(filmDetaylari.Year ?? "N/A")
        Rated: \(filmDetaylari.Rated ?? "N/A")
        Released: \(filmDetaylari.Released ?? "N/A")
        Runtime: \(filmDetaylari.Runtime ?? "N/A")
        Genre: \(filmDetaylari.Genre ?? "N/A")
        Director: \(filmDetaylari.Director ?? "N/A")
        Writer: \(filmDetaylari.Writer ?? "N/A")
        Language: \(filmDetaylari.Language ?? "N/A")
        Country: \(filmDetaylari.Country ?? "N/A")
        Awards: \(filmDetaylari.Awards ?? "N/A")
        Metascore: \(filmDetaylari.Metascore ?? "N/A")
        IMDB Votes: \(filmDetaylari.imdbVotes ?? "N/A")
        Box Office: \(filmDetaylari.BoxOffice ?? "N/A")
        """

        if let ratings = filmDetaylari.Ratings, !ratings.isEmpty {
            detayMetni += "\nRatings:\n"
            for rating in ratings {
                detayMetni += "- \(rating.Source): \(rating.Value)\n"
            }
        }
        
        if let posterURL = filmDetaylari.Poster, let url = URL(string: posterURL) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data, error == nil {
                        DispatchQueue.main.async {
                            self.filmDetayImage.image = UIImage(data: data)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.filmDetayImage.image = UIImage(named: "placeholder")
                        }
                    }
                }.resume()
            } else {
                self.filmDetayImage.image = UIImage(named: "placeholder")
            }


        
        detaylarLabel.text = detayMetni
        filmDetayImage.image = UIImage(named: filmDetaylari.Poster ?? "defaultImage")
        filmDetayTitle.text = filmDetaylari.Title
        filmDetayAciklama.text = "Plot:\n\(filmDetaylari.Plot ?? "N/A")"
        filmActorsLabel.text = "Actors:\n\(filmDetaylari.Actors ?? "N/A")"
    }
    
    private func setupGradientForPart4() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            backGroundColor?.cgColor ?? UIColor.white.cgColor,
            viewColor?.cgColor ?? UIColor.white.cgColor
        ]
        
        gradientLayer.locations = [0.0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: part4View.bounds.width,
            height: part4View.bounds.height
        )
        
        part4View.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        part4View.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradientForPart4()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setupGradientForPart4()
        }
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in
            self.setupGradientForPart4()
        }
    }
    
    private func fetchFilmDetails(imdbID: String) {
        let viewModel = filmDetayViewModel()
        viewModel.filmDetayYukle(imdbID: imdbID) { [weak self] detaylar in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let detaylar = detaylar {
                    self.filmDetaylari = detaylar
                    self.displayContent()
                    
                    self.part2View.isHidden = false
                    self.part3View.isHidden = false
                    self.part4View.isHidden = false
                } else {
                    print("Ekran yüklenemedi")
                }
            }
        }
    }
}
    
