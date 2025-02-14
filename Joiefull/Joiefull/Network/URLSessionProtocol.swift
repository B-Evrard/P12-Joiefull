//
//  URLSessionProtocol.swift
//  Joiefull
//
//  Created by Bruno Evrard on 13/02/2025.
//


import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}