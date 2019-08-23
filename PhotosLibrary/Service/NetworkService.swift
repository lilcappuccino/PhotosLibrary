//
//  NetworkService.swift
//  PhotosLibrary
//
//  Created by dewill on 23/08/2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import Foundation

class NetworkService {
    
    private let accesKey = "5f21896c58a22601dc0bd11d6a35c8ab75256cdd90a2ce17a79101efc4565cb5"
    
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void){
        let params = preapreParams(searchTerm: searchTerm)
        guard let url = self.url(params: params) else { return }
        let header  = prepareHeader()
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()

    }
    
    private func prepareHeader() -> [String: String]{
        var header = [String: String]()
        header["Authorization"] = "Client-ID \(accesKey)"
        return header
    }
    
    private func preapreParams(searchTerm: String) -> [String: String] {
        var params =  [String: String]()
        params["query"] = searchTerm
        params["page"] = String(1)
        params["per_page"] = String(30)
        return params
    }

    private func url(params: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map{ URLQueryItem(name: $0, value: $1) }
        return components.url
    }
    
    
    private  func createDataTask(from request : URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask {
        return  URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
