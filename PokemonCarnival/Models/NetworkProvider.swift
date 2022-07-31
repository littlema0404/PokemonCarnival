//
//  NetworkProvider.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Combine
import Moya

class NetworkProvider: MoyaProvider<MultiTarget> {
    private let requestBuilderPlugin: RequestBuilderPlugin
    private let apiVersion: String = "v2/"
    private let domain = "https://pokeapi.co/api/"

    var apiEntryPoint: String {
        requestBuilderPlugin.apiEntryPoint
    }

    init(forTesting: Bool, session: Session? = nil) {
        requestBuilderPlugin = RequestBuilderPlugin(domain: domain, apiVersion: apiVersion)
        let logger = NetworkLoggerPlugin()
        logger.configuration.logOptions = .formatRequestAscURL
        let plugins = [requestBuilderPlugin, logger] as [PluginType]

        let stubClosure = forTesting ? MoyaProvider<MultiTarget>.immediatelyStub : MoyaProvider<MultiTarget>.neverStub
        if let session = session {
            super.init(stubClosure: stubClosure, session: session, plugins: plugins)
        } else {
            super.init(stubClosure: stubClosure, plugins: plugins)
        }
    }
    
    func requestPublisher(endPoint: TargetType) -> AnyPublisher<Response, Error> {
        requestPublisher(MultiTarget(endPoint), callbackQueue: .main).filterSuccessfulStatusCodes().tryCatch { error in
            Fail(error: error)
        }.eraseToAnyPublisher()
    }
}
