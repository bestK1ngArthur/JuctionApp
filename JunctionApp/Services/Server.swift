//
//  Server.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import UIKit

class Server {
    typealias VoidCompletion = () -> Void
    typealias RoomCompletion = (Room) -> Void
    typealias PlacesCompletion = ([Place]) -> Void

    static let current = Server()
    
    func createUser(_ user: User, completion: @escaping VoidCompletion) {
        let url = baseURL.appendingPathComponent("user")
        
        request(.post, modelType: VoidResponse.self, url: url, body: ["username": user.identifier]) { response in
            guard case .success = response else { return }

            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func createRoom(for user: User, completion: @escaping RoomCompletion) {
        let url = baseURL.appendingPathComponent("room")

        request(.post, modelType: Room.self, url: url) { response in
            guard case let .success(room) = response else { return }

            DispatchQueue.main.async {
                completion(room)
            }
        }
    }
        
    func getRoom(for roomID: RoomID, completion: @escaping RoomCompletion) {
        let url = baseURL.appendingPathComponent("room/\(roomID)")

        request(.get, modelType: Room.self, url: url) { response in
            guard case let .success(room) = response else { return }

            DispatchQueue.main.async {
                completion(room)
            }
        }
    }
    
    func joinRoom(for roomID: RoomID, completion: @escaping RoomCompletion) {
        let url = baseURL.appendingPathComponent("room/\(roomID)/join")

        request(.get, modelType: Room.self, url: url) { response in
            guard case let .success(room) = response else { return }

            DispatchQueue.main.async {
                completion(room)
            }
        }
    }
    
    func getFirstPlaces(completion: @escaping PlacesCompletion) {
        let url = baseURL.appendingPathComponent("business/kUPlKgW6OLRw8_rrYtBV3A")
        
        request(.get, modelType: Place.self, url: url) { response in
            guard case let .success(place) = response else { return }

            DispatchQueue.main.async {
                completion([place, place])
            }
        }
    }
        
    func choosePlace(_ placeID: PlaceID, completion: @escaping PlacesCompletion) {
        getFirstPlaces(completion: completion)
    }
    
    // MARK: Requests
    
    private let baseURL = URL(string: "http://84.201.163.58:33319/api/v1")!
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private var latitude: String? {
        guard let latitude = Locator.current.location?.coordinate.latitude else { return nil }
        return String(latitude)
    }
    
    private var longitude: String? {
        guard let longitude = Locator.current.location?.coordinate.longitude else { return nil }
        return String(longitude)
    }
    
    private lazy var headers = [
        "Authorization": "bearer \(UIDevice.current.identifierForVendor!.uuidString)",
        "X-Latitude": latitude ?? "55.718070",
        "X-Longitude": longitude ?? "37.424821",
        "X-City": Locator.current.city ?? "Moscow",
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
        
    private func request<Model: Decodable>(_ type: RequestType, modelType: Model.Type, url: URL, body: [String: String]? = nil, completion: @escaping (Result<Model>) -> Void) {
        switch type {
        case .get:
            get(url: url, modelType: modelType, completion: completion)
        case .post:
            post(url: url, body: body, modelType: modelType, completion: completion)
        }
    }
    
    private func get<Model: Decodable>(url: URL, modelType: Model.Type, completion: @escaping (Result<Model>) -> Void) {
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        headers.forEach { field, value in
            request.addValue(value, forHTTPHeaderField: field)
        }
                
        let task = session.dataTask(with: request) { [unowned self] data, response, error in
            if let error = error, data == nil {
                completion(.failure(error))
            }
            
            guard let data = data else { return }
            
            do {
                let model = try self.decoder.decode(Model.self, from: data)
                completion(.success(model))
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    private func post<Model: Decodable>(url: URL, body: [String: String]? = nil, modelType: Model.Type, completion: @escaping (Result<Model>) -> Void) {
        var request = URLRequest(url: url)
                
        headers.forEach { field, value in
            request.addValue(value, forHTTPHeaderField: field)
        }
        
        request.httpMethod = "POST"
        
        if let body = body, let encodedData = try? encoder.encode(body) {
            request.httpBody = encodedData
        }
        
        let task = session.dataTask(with: request) { [unowned self] data, response, error in
            if let error = error, data == nil {
                completion(.failure(error))
            }
            
            guard let data = data else { return }
            
            do {
                let model = try self.decoder.decode(Model.self, from: data)
                completion(.success(model))
            } catch let error {
                fatalError(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}

extension Server {
    enum Result<Model: Decodable> {
        case success(Model)
        case failure(Error)
    }
    
    enum RequestType {
        case get
        case post
    }
}

extension Server {

    struct VoidResponse: Decodable {}

    struct PlacesResponse: Decodable {
        let results: [Place]
    }
}
