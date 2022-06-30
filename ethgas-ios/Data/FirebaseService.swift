//
//  FirebaseService.swift
//  ethgas-ios
//
//  Created by mgarciate on 17/01/2021.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol FirebaseService {
    func currentData(completion: @escaping (Result<CurrentData, Error>) -> Void)
    func saveToken(fcmToken: String)
    func currentAlerts(completion: @escaping (Result<AlertsGas, Error>) -> Void)
    func removeCurrentAlertsObserver()
    func saveAlert(_ alert: AlertGas, completion: @escaping (Result<AlertGas, Error>) -> Void)
    func removeAlert(_ alert: AlertGas, completion: @escaping (Result<Bool, Error>) -> Void)
    func graphs(completion: @escaping (Result<Graphs, Error>) -> Void)
}

class FirebaseServiceImpl: FirebaseService {
    let ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    func currentData(completion: @escaping (Result<CurrentData, Error>) -> Void) {
        ref.child("gasprice/current/values").observe(.value) { snapshot in
            // Get gas price value
            guard let value = snapshot.value as? NSDictionary,
                  let id = value["uid"] as? Int,
                  let ethusd = value["ethusd"] as? Double,
                  let blockNum = value["blockNum"] as? Int,
                  let fastest = value["fastest"] as? Int,
                  let fast = value["fast"] as? Int,
                  let average = value["average"] as? Int,
                  let averageMax24h = value["averageMax24h"] as? Int,
                  let averageMin24h = value["averageMin24h"] as? Int,
                  let fastMax24h = value["fastMax24h"] as? Int,
                  let fastMin24h = value["fastMin24h"] as? Int,
                  let fastestMax24h = value["fastestMax24h"] as? Int,
                  let fastestMin24h = value["fastestMin24h"] as? Int else {
                return
            }
            completion(.success(CurrentData(timestamp: id, ethusd: ethusd, blockNum: blockNum,fastest: fastest, fast: fast, average: average, averageMax24h: averageMax24h, averageMin24h: averageMin24h, fastMax24h: fastMax24h, fastMin24h: fastMin24h, fastestMax24h: fastestMax24h, fastestMin24h: fastestMin24h)))
        }
    }
    
    func saveToken(fcmToken: String) {
        guard let user = Auth.auth().currentUser else { return }
        let post = [
            "platform": "ios",
            "token": fcmToken,
            "userId": user.uid
        ]
        let childUpdates = ["/users/\(user.uid)/tokens/\(fcmToken)": post,
                            "/deviceTokens/\(fcmToken)": post]
        ref.updateChildValues(childUpdates)
    }
    
    func currentAlerts(completion: @escaping (Result<AlertsGas, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        ref.child("users/\(user.uid)/alerts").observe(.value) { snapshot in
            var alerts = [AlertGas]()
            for child in snapshot.children {
                guard let value = (child as? DataSnapshot)?.value as? NSDictionary,
                      let id = value["uid"] as? String,
                      let gas = value["value"] as? Int,
                      let directionString = value["direction"] as? String,
                      let direction = AlertGasDirection(rawValue: directionString),
                      let type = AlertGasType(rawValue: value["type"] as? String ?? "standard"),
                      let frequency = AlertGasFrequency(rawValue: value["frequency"] as? String ?? "once") else {
                    return
                }
                alerts.append(AlertGas(id: id, value: gas, direction: direction, type: type, frequency: frequency))
            }
            completion(.success(AlertsGas(alerts: alerts)))
        }
    }
    
    func removeCurrentAlertsObserver() {
        guard let user = Auth.auth().currentUser else { return }
        ref.child("users/\(user.uid)/alerts").removeAllObservers()
    }
    
    func saveAlert(_ alert: AlertGas, completion: @escaping (Result<AlertGas, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        guard let key = ref.child("users/\(user.uid)/alerts").childByAutoId().key else { return }
        let post = ["uid": key,
                    "value": alert.value,
                    "direction": alert.direction.rawValue,
                    "type": alert.type.rawValue,
                    "userId": user.uid,
                    "frequency": alert.frequency.rawValue] as [String : Any]
        let childUpdates = ["/users/\(user.uid)/alerts/\(key)": post,
                            "/alertsUpDown/\(key)": post]
        ref.updateChildValues(childUpdates) { error, ref in
            guard let error = error else {
                completion(.success(AlertGas(id: key, value: alert.value, direction: alert.direction, type: alert.type, frequency: alert.frequency)))
                return
            }
            completion(.failure(error))
        }
    }
    
    func removeAlert(_ alert: AlertGas, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let childUpdates = ["/users/\(user.uid)/alerts/\(alert.id)": [],
                            "/alertsUpDown/\(alert.id)": []]
        ref.updateChildValues(childUpdates) { error, ref in
            guard let error = error else {
                completion(.success(true))
                return
            }
            completion(.failure(error))
        }
    }
    
    func graphs(completion: @escaping (Result<Graphs, Error>) -> Void) {
        guard let _ = Auth.auth().currentUser else { return }
        ref.child("gasprice/graph").observe(.value) { snapshot in
            var dailyEntries = [GraphEntry]()
            for child in snapshot.childSnapshot(forPath: "daily").children {
                guard let value = (child as? DataSnapshot)?.value as? NSDictionary,
                      let timestamp = value["timestamp"] as? Int,
                      let ethusd = value["ethusd"] as? Double,
                      let fastest = value["fastest"] as? Int,
                      let fast = value["fast"] as? Int,
                      let average = value["average"] as? Int else {
                    return
                }
                dailyEntries.append(GraphEntry(timestamp: timestamp, ethusd: ethusd, fastest: fastest, fast: fast, average: average))
            }
            var weeklyEntries = [GraphEntry]()
            for child in snapshot.childSnapshot(forPath: "weekly").children {
                guard let value = (child as? DataSnapshot)?.value as? NSDictionary,
                      let timestamp = value["timestamp"] as? Int,
                      let ethusd = value["ethusd"] as? Double,
                      let fastest = value["fastest"] as? Int,
                      let fast = value["fast"] as? Int,
                      let average = value["average"] as? Int else {
                    return
                }
                weeklyEntries.append(GraphEntry(timestamp: timestamp, ethusd: ethusd, fastest: fastest, fast: fast, average: average))
            }
            completion(.success(Graphs(daily: dailyEntries, weekly: weeklyEntries)))
        }
    }
}
