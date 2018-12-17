//
//  User.swift
//  Teste-Eokoe
//
//  Created by Rick on 13/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit

struct Bio: Decodable {
    let mini : String?
    let full : String?
}

struct Name: Decodable {
    let first : String?
    let last : String?
    let title : String?
}

struct Picture: Decodable {
    let large : URL?
    let medium : URL?
    let thumbnail : URL?
}

struct Location: Decodable {
    let city : String?
    let postcode : Int?
    let state : String?
    let street : String?
}

struct Profile: Decodable {
    var background_image : URL?
}

struct Pagination : Decodable {
    let limit : Int?
    let start : Int?
}

struct UserList: Decodable {
    let pagination : Pagination?
    let results : [User]?
    
    static func fetchUsersList(start: Int, limit: Int, _ completionHandler: @escaping (UserList) -> ()) {
    
        let urlString = "http://testmobiledev.eokoe.com/users?start=\(start)&limit=\(limit)"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.setValue("d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35", forHTTPHeaderField: "X-API-Key")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    

        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (receivedData, response, err) -> Void in
            guard let data = receivedData else { print("Data error on rest users"); return }
            print(data)
            if let error = err {
                print(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userlist = try decoder.decode(UserList.self, from: data)
//                print(userlist)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(userlist)
                })
                
            } catch let err {
                print("Json parse error: ",err)
            }
            
        }).resume()
    
    }
}

struct User: Decodable {
    let id : Int?
    let avg_customer : Float?
    let nat : String?
    let cell : String?
    let dob : String?
    let registered : String?
    let email : String?
    let gender : String?
    let bio : Bio?
    let name : Name?
    let picture : Picture?
    let location : Location?
    var profile : Profile?
    
    static func fetchUser(id : Int, _ completionHandler: @escaping (User) -> ()) {
        
        let urlString = "http://testmobiledev.eokoe.com/user/\(id)"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.setValue("d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35", forHTTPHeaderField: "X-API-Key")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (receivedData, response, err) -> Void in
            guard let data = receivedData else { return }
            print(data)
            if let error = err {
                print(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                print(user)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(user)
                })
                
            } catch let err {
                print(err)
            }
            
        }).resume()
        
    }
}
