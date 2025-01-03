//
//  filmlerListe.swift
//  MovieApp
//
//  Created by Bertan Taşman on 16.12.2024.
//

import Foundation
import Alamofire

class filmlerListe: Codable {
    var Title: String?
    var Year: String?
    var imdbID: String?
    var type: String?
    var Poster: String?
    var imdbRating: String?

    enum CodingKeys: String, CodingKey {
        case Title
        case Year
        case imdbID
        case type = "Type"
        case Poster
    }

    init(Title: String, Year: String, imdbID: String, type: String, Poster: String, imdbRating: String? = nil) {
        self.Title = Title
        self.Year = Year
        self.imdbID = imdbID
        self.type = type
        self.Poster = Poster
        self.imdbRating = imdbRating
    }
}
