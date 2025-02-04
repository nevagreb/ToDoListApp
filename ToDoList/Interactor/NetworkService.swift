//
//  NetworkService.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 04.02.2025.
//

import Foundation

// протокол для сетевого сервиса
protocol NetworkServiceProtocol {
    func fetchData(from url: URL) async throws -> Data
}

// структура - сервис для работы с сетью
struct NetworkService: NetworkServiceProtocol {
    func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
