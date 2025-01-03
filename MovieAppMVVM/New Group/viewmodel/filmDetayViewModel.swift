//
//  filmDetayViewModel.swift
//  MovieAppMVVM
//
//  Created by Bertan Taşman on 24.12.2024.
//

import Foundation

class filmDetayViewModel{
    var frepo = filmlerDaoRepository()
    
    func filmDetayYukle(imdbID: String, completion: @escaping (detaylarListe?) -> Void) {
        frepo.filmDetayYukle(imdbID: imdbID, completion: completion)
    }

}
