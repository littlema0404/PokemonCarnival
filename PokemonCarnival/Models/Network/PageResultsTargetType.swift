//
//  PageResultsTargetType.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/1.
//

import Moya

struct PageResultsTargetType: TargetType {
    var targetType: TargetType
    var offset: Int
    var limit: Int

    var baseURL: URL {
        return targetType.baseURL
    }

    var path: String {
        return targetType.path
    }

    var method: Moya.Method {
        return targetType.method
    }

    var sampleData: Data {
        return targetType.sampleData
    }

    var task: Task {
        switch targetType.task {
        case .requestParameters(parameters: var parameters, encoding: let encoding):
            parameters["offset"] = String(offset)
            parameters["limit"] = String(limit)
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .requestPlain:
            var parameters: [String: Any] = [:]
            parameters["offset"] = String(offset)
            parameters["limit"] = String(limit)
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return targetType.task
        }
    }

    var headers: [String: String]? {
        return targetType.headers
    }
}
