//
//  NetworkWrapper.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Alamofire
import Moya

final class NetworkWrapper {
    static let shared = NetworkWrapper()
    
    private init() {}

    private func provider(_ token: String? = nil, customHeader: HTTPHeaders? = nil) -> MoyaProvider<NetworkService> {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        
        if let customHeader = customHeader {
            customHeader.forEach {
                configuration.headers.add($0)
            }
        }
        
        let session: Session = Session(configuration: configuration)
        
        if let token = token {
            let tokenPlugin: AccessTokenPlugin = AccessTokenPlugin { _ in token }
            return MoyaProvider<NetworkService>(session: session, plugins: [tokenPlugin])
        } else {
            return MoyaProvider<NetworkService>(session: session)
        }
    }
    
    func fetchPublicService(_ service: NetworkService) async throws -> Response {
        switch await provider().request(service) {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}

extension MoyaProvider {
    func request(_ target: Target) async -> Result<Response, Error> {
        await withCheckedContinuation { continuation in
            request(target) { result in
                let moderatedResponse = result.mapError { $0 as Error }
                continuation.resume(returning: moderatedResponse)
            }
        }
    }
}
