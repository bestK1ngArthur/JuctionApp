//
//  Server.swift
//  JunctionApp
//
//  Created by Artem Belkov on 07.11.2020.
//

import UIKit

class Server {
    typealias RoomCompletion = (Room) -> Void
    typealias RoomStatusCompletion = (RoomStatus) -> Void
    typealias PlacesCompletion = ([Place]) -> Void

    static let current = Server()
    
    func createRoom(for user: User, completion: @escaping RoomCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            completion(Room(id: 101))
        }
    }
        
    func getRoomStatus(for roomID: RoomID, completion: @escaping RoomStatusCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            completion(RoomStatus(voters: [
                .init(name: "Ivan", status: .voting),
                .init(name: "Katya", status: .finished)
            ], places: []))
        }
    }
    
    func getFirstPlaces(completion: @escaping PlacesCompletion) {
        let url = baseURL.appendingPathComponent("business")
        
        request(.get, modelType: PlacesResponse.self, url: url) { response in
            guard case let .success(data) = response else { return }

            DispatchQueue.main.async {
                completion(data.results)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let place = [Place(name: "Macdonalds", photo: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80", cuisines: ["hui","pizda","scovoroda"], isOpen: true),
                         Place(name: "Ocherednaya Pomoika", photo: "https://d2w1ef2ao9g8r9.cloudfront.net/images/floorplan.png?mtime=20200424135830&focal=none", cuisines: ["pizda","scovoroda"], isOpen: false)]
            completion(place)
        }
    }
        
    func choosePlace(_ placeID: PlaceID, completion: @escaping PlacesCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let place = [Place(name: "Macdonalds2", photo: "https://lh3.googleusercontent.com/proxy/uDypGXLa53HqrzdJxwG9kZbblKS4pqGTbnrp4qUUSTi2rvGUEKEibAlOSIOlAG8LRb3yuGyrlADyQ_s5swehKc7944XPdRf6kbX7GOSgCu0dBXQ76EUwWfnPTP97Sdts8NHoKZ1_e_9lxoFdRw", cuisines: ["hui","pizda","scovoroda"], isOpen: true),
                         Place(name: "Ocherednaya Pomoika 2", photo: "https://restaurantdupalaisroyal.com/wp-content/uploads/2020/02/Restaurant_du_Palais_Royal_RDC_11_GdeLaubier.jpg", cuisines: ["pizda","scovoroda"], isOpen: false)]
            completion(place)
        }
    }
    
    // MARK: Requests
    
    private let baseURL = URL(string: "http://84.201.163.58:8000/api/v1")!
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    private let headers = [
        "Authorization": "bearer \(UIDevice.current.identifierForVendor!.uuidString)",
        "X-Latitude": "55.718070",
        "X-Longitude": "37.424821",
        "X-City": "Moscow"
    ]
    
    private func request<Model: Decodable>(_ type: RequestType, modelType: Model.Type, url: URL, completion: @escaping (Result<Model>) -> Void) {
        switch type {
        case .get:
            get(url: url, modelType: modelType, completion: completion)
        case .post:
            fatalError("Not implemented")
        }
    }
    
    private func get<Model: Decodable>(url: URL, modelType: Model.Type, completion: @escaping (Result<Model>) -> Void) {
        
        var request = URLRequest(url: url)
        
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
    
    struct PlacesResponse: Decodable {
        let results: [Place]
    }
}
