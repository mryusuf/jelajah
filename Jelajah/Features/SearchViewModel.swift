//
//  SearchViewModel.swift
//  Jelajah
//
//  Created by Indra Permana on 02/07/22.
//

import RxSwift
import RxRelay

enum SortOptions {
    case distance
    case rating
}

protocol SearchViewModelProtocol {
    var businessItems: Observable<[Business]> { get }
    var isLoading: Observable<Bool> { get }
    func postSearchQuery(with query: String)
    func sortItems(by option: SortOptions)
}

final class SearchViewModel: SearchViewModelProtocol {
    private let locationService: LocationServiceProtocol
    private let searchRepository: SearchRepositoryProtocol
    private let businessItemsRelay: BehaviorRelay<[Business]> = .init(value: [])
    private let isLoadingSubject: PublishSubject<Bool> = .init()
    private let disposeBag = DisposeBag()
    
    var businessItems: Observable<[Business]> {
        businessItemsRelay.asObservable()
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
                self?.businessItemsRelay.accept(data.businesses ?? [])
            }, onError: { error in
                print(error.asAFError?.localizedDescription)
            }, onCompleted: { [weak self] in
                self?.isLoadingSubject.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func sortItems(by option: SortOptions) {
        var items = businessItemsRelay.value
        
        switch option {
        case .distance:
            items.sort(by: {($0.distance ?? 0) < ($1.distance ?? 0)} )
        case .rating:
            items.sort(by: {($0.rating ?? 0) > ($1.rating ?? 0)} )
        }
        
        businessItemsRelay.accept(items)
    }
    
}
