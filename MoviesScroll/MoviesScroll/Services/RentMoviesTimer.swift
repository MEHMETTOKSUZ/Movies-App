//
//  UserdefaultsTimer.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 9.04.2023.
//

import Foundation


class RentMoviesTimer {
    
    static let shared = RentMoviesTimer()
    private init() {}
    
    func removeRentMoviesFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        let currentDate = Date()
        let expiredInterval: TimeInterval = 20.0
        
        if let data = userDefaults.object(forKey: "RentMovies") as? Data {
            if var loadedRentMovies = try? JSONDecoder().decode([Results].self, from: data) {
                
                loadedRentMovies = loadedRentMovies.filter { movie in
                    if let rentalDate = userDefaults.object(forKey: "\(movie.id)_rental_date") as? Date {
                        let timeElapsed = currentDate.timeIntervalSince(rentalDate)
                        if timeElapsed < expiredInterval {
                            return true
                        } else {
                            userDefaults.removeObject(forKey: "\(movie.id)_rental_date")
                            return false
                        }
                    } else {
                        return true
                    }
                }
                
                userDefaults.set(try? JSONEncoder().encode(loadedRentMovies), forKey: "RentMovies")
                userDefaults.synchronize()
            }
        }
    }
}

