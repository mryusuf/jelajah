//
//  SearchRepository.swift
//  Jelajah
//
//  Created by Indra Permana on 02/07/22.
//

import Alamofire
import RxSwift

protocol SearchRepositoryProtocol {
    func fetchSearchData(params: SearchQueryModel) -> Observable<BusinessModel>
}

struct SearchRepository: SearchRepositoryProtocol {
    
    func fetchSearchData(params: SearchQueryModel) -> Observable<BusinessModel> {
        return Observable<BusinessModel>.create { observer in
            if let url = URL(string: Endpoints.businessSearch.url) {
                AF.request(
                    url,
                    method: Endpoints.businessSearch.httpMethod,
                    parameters: params,
                    headers: Endpoints.businessSearch.headers
                )
                    .validate()
                    .responseDecodable(of: BusinessModel.self) { response in
                        switch response.result {
                        case .success(let value):
                            observer.onNext(value)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(NSError(domain: "SearchRepository Error: \(error.localizedDescription)", code: error.responseCode ?? 400))
                        }
                    }
            }
            return Disposables.create()
        }
    }
}

