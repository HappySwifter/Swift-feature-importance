//
//  Mse.swift
//
//  Created by Artem on 18.02.2024.
//

import Foundation

public struct Mse: Identifiable {
    public var id: String {
        feature
    }    
    /// Feature name
    public let feature: String
    /// Diff with training error
    public let train: Double
    /// Diff with validation error
    public let validate: Double
    
    public init(feature: String, train: Double, validate: Double) {
        self.feature = feature
        self.train = train
        self.validate = validate
    }
}
