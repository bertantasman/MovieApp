//
//  filmlerDaoRepository.swift
//  MovieAppMVVM
//
//  Created by Bertan Taşman on 23.12.2024.
//

import Foundation
import RxSwift
import Alamofire

class filmlerDaoRepository {
    
    var filmlerListesi = BehaviorSubject<[filmlerListe]>(value: [filmlerListe]())
    private let disposeBag = DisposeBag()
    private var currentPage = 1
    private var isLoading = false
    private var totalResults = 0
    
    func filmDetayYukle(imdbID: String, completion: @escaping (detaylarListe?) -> Void) {
        let url = "https://www.omdbapi.com/?apikey=5ebb2b23&i=\(imdbID)"
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do {
                    let detaylar = try JSONDecoder().decode(detaylarListe.self, from: data)
                    completion(detaylar)
                } catch {
                    print("Film detayları decode hatası: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }

    func filmleriYukle() {
        guard !isLoading else { return }
        isLoading = true

        let url = "https://www.omdbapi.com/?apikey=5ebb2b23&s=star&page=\(currentPage)"
        AF.request(url, method: .get).response { response in
            self.isLoading = false
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(filmlerListeCevap.self, from: data)
                    if let liste = cevap.Search {
                        var currentList = try self.filmlerListesi.value()

                        currentList.append(contentsOf: liste)
                        self.filmlerListesi.onNext(currentList)

                        self.totalResults = Int(cevap.totalResults ?? "0") ?? 0

                        self.updateFilmDetails(for: liste)
                    }
                } catch {
                    print("FilmleriYukle JSON decode hatası: \(error.localizedDescription)")
                }
            }
        }
    }

    private func updateFilmDetails(for liste: [filmlerListe]) {
        let dispatchGroup = DispatchGroup()
        var updatedList = liste

        for (index, film) in liste.enumerated() {
            dispatchGroup.enter()
            if let imdbID = film.imdbID {
                self.filmDetayYukle(imdbID: imdbID) { detaylar in
                    if let detaylar = detaylar {
                        updatedList[index].imdbRating = detaylar.imdbRating
                    }
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            do {
                var currentList = try self.filmlerListesi.value()
                for updatedFilm in updatedList {
                    if let index = currentList.firstIndex(where: { $0.imdbID == updatedFilm.imdbID }) {
                        currentList[index] = updatedFilm
                    }
                }
                self.filmlerListesi.onNext(currentList)
            } catch {
                print("Film listesi güncellenemedi: \(error.localizedDescription)")
            }
        }
    }

    func ara(aramaKelimesi: String) {
        guard !isLoading else { return }
        isLoading = true
        currentPage = 1

        let url = "https://www.omdbapi.com/?apikey=5ebb2b23&s=\(aramaKelimesi)&page=\(currentPage)"
        AF.request(url, method: .get).response { response in
            self.isLoading = false
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(filmlerListeCevap.self, from: data)
                    if let liste = cevap.Search {
                        self.filmlerListesi.onNext(liste)
                        self.totalResults = Int(cevap.totalResults ?? "0") ?? 0

                        self.updateFilmDetails(for: liste)
                    } else {
                        self.filmlerListesi.onNext([])
                    }
                } catch {
                    print("Arama JSON decode hatası: \(error.localizedDescription)")
                    self.filmlerListesi.onNext([])
                }
            } else if let error = response.error {
                print("Arama isteği hatası: \(error.localizedDescription)")
            }
        }
    }

    func loadMore(aramaKelimesi: String?) {
        guard !isLoading, filmlerListesiHasMore() else { return }
        isLoading = true
        currentPage += 1

        let searchTerm = aramaKelimesi ?? "star"
        let url = "https://www.omdbapi.com/?apikey=5ebb2b23&s=\(searchTerm)&page=\(currentPage)"
        
        AF.request(url, method: .get).response { response in
            self.isLoading = false
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(filmlerListeCevap.self, from: data)
                    if let liste = cevap.Search {
                        var currentList = try self.filmlerListesi.value()
                        currentList.append(contentsOf: liste)
                        self.filmlerListesi.onNext(currentList)

                        
                        self.updateFilmDetails(for: liste)
                    }
                } catch {
                    print("Load more JSON decode hatası: \(error.localizedDescription)")
                }
            }
        }
    }

    private func filmlerListesiHasMore() -> Bool {
        let currentCount = (try? filmlerListesi.value().count) ?? 0
        return currentCount < totalResults
    }
}
