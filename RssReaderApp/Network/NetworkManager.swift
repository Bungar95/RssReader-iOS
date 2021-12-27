//
//  NetworkManager.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 23.12.2021..
//

import Foundation
import Alamofire
import RxSwift
import XMLCoder

class NetworkManager{
    
    func getData<T: Codable>(from urlString: String) -> Observable<T>{
        
        return Observable.create{ observer in
            let request = AF.request(urlString)
                .validate().responseData{ networkResponse in
                    switch networkResponse.result{
                    case .success:
                        do{
                            let response = try networkResponse.result.get()
                            let xml = try! XMLDecoder().decode(RssResponse.self, from: response)
                            observer.onNext(xml as! T)
                            observer.onCompleted()
                        }
                        catch(let error){
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
