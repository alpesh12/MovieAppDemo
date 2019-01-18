//
//  MovieAPI.swift
//  MovieApp
//
//  Created by Jayesh on 17/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import Foundation
import RxSwift
import Moya

let MovieProvider = MoyaProvider<MovieAPI>()

public enum MovieAPI {
    case Home()
    case Search(keyword: String, offset: Int)
    case LoadMore(keyword: String, offset: Int, type: String)
}

extension MovieAPI: TargetType {

    public var baseURL: URL {
        return URL(string: "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp")!
    }
    
    public var path: String {
        switch self {
        case .Home:
            return "/home"
        case .Search:
            return "/search"
        case .LoadMore:
            return "/loadmore"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"];
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .Home:
            return nil
        case let .Search(keyword, offset):
            return ["keyword":keyword, "offset":offset]
        case let .LoadMore(keyword, offset, type):
            return ["keyword":keyword, "offset":offset, "type":type]
        }
    }
}

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
