//
//  SearchViewModel.swift
//  Jelajah
//
//  Created by Indra Permana on 02/07/22.
//

import RxSwift

protocol SearchViewModelProtocol {
    var businessModel: Observable<BusinessModel> { get }
    func postSearchQuery(with query: String)
}

final class SearchViewModel: SearchViewModelProtocol {
    private let locationService: LocationServiceProtocol
    private let searchRepository: SearchRepositoryProtocol
    private let businessModelSubject: PublishSubject<BusinessModel> = .init()
    private let disposeBag = DisposeBag()
    
    var businessModel: Observable<BusinessModel> {
        businessModelSubject.asObservable()
    }
    
    init(
        locationService: LocationServiceProtocol = LocationService(),
        searchRepository: SearchRepositoryProtocol = SearchRepository()
    ) {
        self.locationService = locationService
        self.searchRepository = searchRepository
    }
    
    
    func postSearchQuery(with query: String) {
        
        locationService.getCurrentLatituteLongitude()
            .flatMapLatest { center in
                self.searchRepository.fetchSearchData(params: SearchQueryModel(term: query, latitude: center.latitude, longitude: center.longitude))
            }
            .take(1)
            .subscribe(onNext: { data in
                print(data)
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
}
