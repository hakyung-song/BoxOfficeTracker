//
//  JSONConvertible.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Foundation

public protocol JSONConvertible {
    var jsonEncoder: JSONEncoder { get }
    func toJSONData() throws -> Data
    func toJSONDictionary() throws -> [String: Any]
}

extension JSONConvertible where Self: Encodable {
    public var jsonEncoder: JSONEncoder {
        return JSONEncoder()
    }
    
    public func toJSONData() throws -> Data {
        return try jsonEncoder.encode(self)
    }
    
    public func toJSONDictionary() throws -> [String: Any] {
        let data = try self.toJSONData()
        let jsonData = try JSONSerialization.jsonObject(with: data)
        let jsonDictionary = jsonData as? [String: Any]
        return jsonDictionary ?? [:]
    }
}
