//
//  SearchViewModel.swift
//  Jelajah
//
//  Created by Indra Permana on 02/07/22.
//

import RxSwift

protocol SearchViewModelProtocol {
    var businessModel: Observable<BusinessModel> { get }
    var isLoading: Observable<Bool> { get }
    func postSearchQuery(with query: String)
}

final class SearchViewModel: SearchViewModelProtocol {
    private let locationService: LocationServiceProtocol
    private let searchRepository: SearchRepositoryProtocol
    private let businessModelSubject: PublishSubject<BusinessModel> = .init()
    private let isLoadingSubject: PublishSubject<Bool> = .init()
    private let disposeBag = DisposeBag()
    
    var businessModel: Observable<BusinessModel> {
        businessModelSubject.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        isLoadingSubject.asObservable()
    }
    
    init(
        locationService: LocationServiceProtocol = LocationService(),
        searchRepository: SearchRepositoryProtocol = SearchRepository()
    ) {
        self.locationService = locationService
        self.searchRepository = searchRepository
    }
    
    
    func postSearchQuery(with query: String) {
        
        isLoadingSubject.onNext(true)
        
        locationService.getCurrentLatituteLongitude()
            .take(1)
            .flatMapLatest { [unowned self] center in
                self.searchRepository.fetchSearchData(params: SearchQueryModel(term: query, latitude: center.latitude, longitude: center.longitude))
            }
            .subscribe(onNext: { [weak self] data in
                print(data)
                self?.businessModelSubject.onNext(data)
            }, onError: { error in
                print(error.asAFError?.localizedDescription)
            }, onCompleted: { [weak self] in
                self?.isLoadingSubject.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
}
