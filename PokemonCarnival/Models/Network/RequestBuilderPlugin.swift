//
//  RequestBuilderPlugin.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Moya

class RequestBuilderPlugin: PluginType {
    private let apiVersion: String
    private let domain: String
    
    var apiEntryPoint: String {
        "\(domain)\(apiVersion)"
    }

    init(domain: String, apiVersion: String) {
        self.domain = domain
        self.apiVersion = apiVersion
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        var urlPathString = request.url?.absoluteString ?? ""
        urlPathString = (urlPathString.hasPrefix("/")) ? String(urlPathString.suffix(urlPathString.count - 1)) : urlPathString

        let fullUrlString = "\(apiEntryPoint)\(urlPathString)"
        request.url = URL(string: fullUrlString)

        return request
    }
}
