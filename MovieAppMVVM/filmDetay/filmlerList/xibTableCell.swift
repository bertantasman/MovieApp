//
//  xibTableCell.swift
//  MovieApp
//
//  Created by Bertan Taşman on 21.12.2024.
//

import UIKit

class xibTableCell: UITableViewCell {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var iIcon: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var filmRating: UILabel!
    @IBOutlet weak var filmYear: UILabel!
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var filmImage: UIImageView!
    var shadowColor = UIColor(named: "tableRenk")

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
        setupIconColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupViews() {
        
        yearLabel.text = "Year:"
        imdbLabel.text = "IMDB:"
        
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.layer.cornerRadius = 15
        innerView.layer.shadowColor = shadowColor?.cgColor
        innerView.layer.shadowOpacity = 0.4
        innerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        innerView.layer.shadowRadius = 10
        innerView.layer.masksToBounds = false

        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            innerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            innerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            innerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            innerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        filmImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filmImage.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 15),
            filmImage.centerYAnchor.constraint(equalTo: innerView.centerYAnchor),
            filmImage.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 15),
            filmImage.heightAnchor.constraint(equalToConstant: 155),
            filmImage.widthAnchor.constraint(equalToConstant: 110)
        ])

        
        filmName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filmName.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 15),
            filmName.leadingAnchor.constraint(equalTo: filmImage.trailingAnchor, constant: 15),
            filmName.trailingAnchor.constraint(equalTo: iIcon.leadingAnchor, constant: -15)
        ])
        filmName.textAlignment = .left
        filmName.font = UIFont.boldSystemFont(ofSize: 18)
        filmName.numberOfLines = 0

        
        iIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iIcon.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 15),
            iIcon.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -15),
            iIcon.heightAnchor.constraint(equalToConstant: 20),
            iIcon.widthAnchor.constraint(equalToConstant: 20)
        ])

        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: filmImage.trailingAnchor, constant: 15),
            stackView.topAnchor.constraint(equalTo: filmName.bottomAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: innerView.bottomAnchor, constant: -15)
        ])


        
        [imdbLabel, yearLabel].forEach { label in
            label?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }

        [filmRating, filmYear].forEach { label in
            label?.font = UIFont.systemFont(ofSize: 16)
        }
    }

    private func setupIconColor() {
        if traitCollection.userInterfaceStyle == .dark {
            iIcon.tintColor = .white
        } else {
            iIcon.tintColor = .black
        }
    }

    @available(iOS, deprecated: 17.0, message: "Use UITraitChangeObservable APIs instead")
override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setupIconColor()
}
}
