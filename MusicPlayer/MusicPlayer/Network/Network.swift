//
//  Network.swift
//  MusicPlayer
//
//  Created by 김기현 on 2020/11/20.
//

import Foundation
import Alamofire

class NetworkRequest {
    static let shared: NetworkRequest = NetworkRequest()
    let baseUrl = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
    
    func request<Response: Decodable>(completion handler: @escaping (Response) -> Void) {
        AF.request(baseUrl, method: .get).responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let obj):
                handler(obj)
            case .failure(let error):
                print("Failure Error: \(error)")
            }
        }
    }
}
