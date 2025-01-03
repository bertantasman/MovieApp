//
//  detaylar.swift
//  MovieApp
//
//  Created by Bertan Taşman on 17.12.2024.
//

import Foundation
import Alamofire
class Rating: Decodable {
    var Source: String
    var Value: String
    
    enum CodingKeys: String, CodingKey {
        case Source = "Source"
        case Value = "Value"
    }
}

class detaylarListe: Decodable {
    var Title: String?
    var Year: String?
    var Rated: String?
    var Released: String?
    var Runtime: String?
    var Genre: String?
    var Director: String?
    var Writer: String?
    var Actors: String?
    var Plot: String?
    var Language: String?
    var Country: String?
    var Awards: String?
    var Poster: String?
    var Ratings: [Rating]?
    var Metascore: String?
    var imdbRating: String?
    var imdbVotes: String?
    var imdbID: String?
    var BoxOffice: String?

    enum CodingKeys: String, CodingKey {
        case Title = "Title"
        case Year = "Year"
        case Rated = "Rated"
        case Released = "Released"
        case Runtime = "Runtime"
        case Genre = "Genre"
        case Director = "Director"
        case Writer = "Writer"
        case Actors = "Actors"
        case Plot = "Plot"
        case Language = "Language"
        case Country = "Country"
        case Awards = "Awards"
        case Poster = "Poster"
        case Ratings = "Ratings"
        case Metascore = "Metascore"
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case imdbID = "imdbID"
        case BoxOffice = "BoxOffice"
    }
}
