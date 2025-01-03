//
//  File.swift
//  MovieAppMVVM
//
//  Created by Bertan Taşman on 24.12.2024.
//

import Foundation
import RxSwift

class ViewControllerViewModel{
    var frepo = filmlerDaoRepository()
    var filmlerListesi = BehaviorSubject<[filmlerListe]>(value: [filmlerListe]())
    
    init(){
        filmlerListesi = frepo.filmlerListesi
        filmleriYukle()
    }
    
    func filmleriYukle(){
        frepo.filmleriYukle()
    }
    
    func ara(aramaKelimesi:String){
        frepo.ara(aramaKelimesi: aramaKelimesi)
    }
}
