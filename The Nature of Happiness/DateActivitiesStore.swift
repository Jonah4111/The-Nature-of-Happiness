//
//  DateActivitiesStore 2.swift
//  The Nature of Happiness
//
//  Created by Jonah Hirst on 7/4/25.
//


import Foundation

class DateActivitiesStore {
    static let shared = DateActivitiesStore()

    private let userDefaultsKey = "DateActivitiesStoreKey"
    private var cache: [String: Data] = [:]

    private init() {
        loadCache()
    }

    // Format date as a key string, e.g. "2025-07-04"
    private func key(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // Load all saved data into cache on init
    private func loadCache() {
        if let savedData = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: Data] {
            cache = savedData
        }
    }

    // Save cache to UserDefaults
    private func saveCache() {
        UserDefaults.standard.set(cache, forKey: userDefaultsKey)
    }

    // Load activities for a specific date
    func load(for date: Date) -> [Activity] {
        let k = key(for: date)
        guard let data = cache[k] else { return [] }
        do {
            let decoded = try JSONDecoder().decode([Activity].self, from: data)
            return decoded
        } catch {
            print("Error decoding activities for \(k): \(error)")
            return []
        }
    }

    // Save activities for a specific date
    func save(_ activities: [Activity], for date: Date) {
        let k = key(for: date)
        do {
            let encoded = try JSONEncoder().encode(activities)
            cache[k] = encoded
            saveCache()
        } catch {
            print("Error encoding activities for \(k): \(error)")
        }
    }
}
