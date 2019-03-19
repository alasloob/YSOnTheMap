//
//  YSClient.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 07/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//
import Foundation

class YSClient {
    
    static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static var AccountLoing: YSLoginResponse? = nil
    
    enum Method: String {
        case POST   = "POST"
        case DELETE = "DELETE"
        case GET    = "GET"
        case PUT    = "PUT"
    }
    
    enum Endpoints {
        // Udacity URL
        static let UdacityBase = "https://onthemap-api.udacity.com/v1"
        static let UdacitySession = "/session"
        // Parse URL
        static let ParseBase = "https://parse.udacity.com"
        static let Parse = "/parse"
        static let Classes = "/classes"
        static let StudentLocation = "/StudentLocation"
        static let Users = "/users"
        
        case login
        case logout
        case student
        case newStudent
        case fakeData(String)
        case put(String)
        case sort(Int)
        case order
        
        var stringValue: String {
            switch self {
                case .login:
                    return Endpoints.UdacityBase + Endpoints.UdacitySession
                case .sort(let limit):
                    return Endpoints.ParseBase + Endpoints.Parse + Endpoints.Classes + Endpoints.StudentLocation + "?limit=\(limit)"
                case .order:
                    return Endpoints.ParseBase + Endpoints.Parse + Endpoints.Classes + Endpoints.StudentLocation + "?order=-updatedAt"
                case .student:
                    return Endpoints.ParseBase + Endpoints.Parse + Endpoints.Classes + Endpoints.StudentLocation
                case .newStudent:
                    return Endpoints.ParseBase + Endpoints.Parse + Endpoints.Classes
                case .logout:
                    return ""
                case .fakeData(let key):
                    return Endpoints.UdacityBase + Endpoints.Users + "/\(key)"
                case .put(let id):
                    return Endpoints.ParseBase + Endpoints.Parse + Endpoints.Classes + Endpoints.StudentLocation + "/\(id)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
}

// MARK: Fetch Student Locations
extension YSClient {
    static func fetchStudentLocation(completion: @escaping ([YSStudentInformation]?, Error?) -> Void) {
        var urlRequest = URLRequest(url: Endpoints.sort(100).url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(AppId, forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue(APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion([] , error)
                }
            } else {
                print("Code : ", (response as! HTTPURLResponse).statusCode)
                if let data = data {
                    do {
                        let locations = try JSONDecoder().decode(YSStudentData.self, from: data)
                        let filter = locations.results.filter({
                            $0.firstName != nil && $0.lastName != nil && $0.mediaURL != nil
                                && $0.latitude != nil && $0.longitude != nil && $0.mapString != nil
                        })
                        DispatchQueue.main.async {
                            completion(filter, nil)
                        }
                    } catch {
                        print("error data " , error)
                        completion([], error)
                    }
                } else {
                    completion([], NSError(domain: "Opps!, try agin another time", code: 4, userInfo: [:]))
                }
            }
        }
        task.resume()
    }
}

// MARK: Login And Logout
extension YSClient {
    static func loginRequest(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var urlRequest = URLRequest(url: Endpoints.login.url)
        urlRequest.httpMethod = Method.POST.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let request = YSUdacityLogin(udacity: YSLoginRequest(username: username, password: password))
            let body = try JSONEncoder().encode(request)
            urlRequest.httpBody = body
            let task = URLSession.shared.dataTask(with: urlRequest) {
                data, response, error in
                if error != nil {
                    DispatchQueue.main.async {
                        completion(false , error)
                    }
                } else {
                    if let data = data {
                        do {
                            let newData = data.subSet(in: 5) /* subset response data! */
                            YSClient.AccountLoing = try JSONDecoder().decode(YSLoginResponse.self, from: newData)
                            DispatchQueue.main.async {
                                completion(true, nil)
                            }
                        } catch {
                            do {
                                let newData = data.subSet(in: 5) /* subset response data! */
                                let errData = try JSONDecoder().decode(YSUdacityLoginError.self, from: newData)
                                let err = NSError(domain: errData.error , code:errData.status)
                                DispatchQueue.main.async {
                                    completion(false, err)
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    completion(false, error)
                                }
                            }
                        }
                    } else {
                        completion(false, NSError(domain: "Opps!, try agin another time", code: 4, userInfo: [:]))
                    }
                }
            }
            task.resume()
        } catch {
            completion(false, error)
        }
    }
    
    static func logout(completion: @escaping (Bool, Error?) -> Void) {
        var urlRequest = URLRequest(url: Endpoints.login.url)
        urlRequest.httpMethod = Method.DELETE.rawValue
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            urlRequest.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false , error)
                }
            } else {
                if let data = data {
                    let newData = data.subSet(in: 5) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } else {
                    completion(false, NSError(domain: "Opps!, try agin another time", code: 4, userInfo: [:]))
                }
            }
        }
        task.resume()
    }
}

// MARK: Response Fake user data

extension YSClient {
    
    static func getFakeData(completion: @escaping (String?, String?, Error?) -> Void) {
        if let account = YSClient.AccountLoing {
            let request = URLRequest(url: Endpoints.fakeData(account.account.key).url)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error...
                    completion(nil, nil, error)
                }
//                let newData = data?.subSet(in: 5) // skip
//                print(String(data: newData!, encoding: .utf8)!) // skip
                completion("Youssef", "Eid", nil) // i want send this name
            }
            task.resume()
        }
    }
    
}


// MARK: Post

extension YSClient {
    
    static func postStudentLocaiton<Request: Encodable>(bodyData: Request, completion: @escaping (Bool?, Error?) -> Void) {
        var request = URLRequest(url: YSClient.Endpoints.student.url)
        request.httpMethod = YSClient.Method.POST.rawValue
        request.addValue(AppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = try! JSONEncoder().encode(bodyData)
        request.httpBody = body
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "Opps!, try agin another time", code: 4, userInfo: [:]))
            }
            
        }
        task.resume()
    }
    
    static func putStudentLocation<Request: Encodable>(id: String, bodyData: Request, completion: @escaping (Bool?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.put(id).url)
        request.httpMethod = Method.PUT.rawValue
        request.addValue(AppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = try! JSONEncoder().encode(bodyData)
        request.httpBody = body
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "Opps!, try agin another time", code: 4, userInfo: [:]))
            }
        }
        task.resume()
    }
    
}
