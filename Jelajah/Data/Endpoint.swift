//
//  Endpoint.swift
//  Jelajah
//
//  Created by Indra Permana on 02/07/22.
//

import Alamofire

struct API {
    
    static let baseUrl = "https://api.yelp.com/v3"
    static let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    
}

protocol Endpoint {
    
    var url: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders { get }
}

enum Endpoints: Endpoint {
    
    case businessSearch
    
    var url: String {
        switch self {
        case .businessSearch:
            return "\(API.baseUrl)/businesses/search"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders {
        return [HTTPHeader.authorization(bearerToken: API.apiKey)]
    }
}
