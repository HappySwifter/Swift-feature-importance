//
//  Regressors.swift
//
//  Created by Artem on 17.02.2024.
//

import Foundation
import CreateML
import TabularData

public struct Regressors {
    public static func trainLinearRegressor(dataFrame: DataFrame, 
                                            targetColumn: String,
                                            l1Penalty: Double = 0) throws -> MLLinearRegressor {
        let params = MLLinearRegressor.ModelParameters(validation: .split(strategy: .automatic), l1Penalty: l1Penalty)
        return try MLLinearRegressor(trainingData: dataFrame, targetColumn: targetColumn, parameters: params)
    }
}
