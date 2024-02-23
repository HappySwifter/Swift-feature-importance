//
//  Predictor.swift
//
//  Created by Artem on 17.02.2024.
//

import Foundation
import TabularData
import CoreML
import CreateML
import OSLog

public struct Predictor {
    private static let logger = Logger(subsystem: "FeatureExtractor", category: "Predictor")
        
    public static func getFeatureImportance(dataFrame: DataFrame,
                                            featureName: String,
                                            regressor: Regressabe,
                                            parameters: EvaluationParameters) throws -> Mse
    {
        let truncated = DataFrame(dataFrame.prefix(parameters.maxRowsCount))
        let shuffledDf = shuffle(columnName: featureName, for: truncated)
        let evaluation = regressor.evaluation(on: shuffledDf)
        if let error = evaluation.error {
            logger.error("Evaluation error: \(error)")
            throw RegressorError.customError(text: error.localizedDescription)
        } else {
            return normalizeErrorValues(feature: featureName,
                                        regressor: regressor,
                                        shuffled: evaluation,
                                        parameters: parameters)
        }
    }
    
    private static func normalizeErrorValues(feature: String,
                                            regressor: Regressabe,
                                            shuffled: MLRegressorMetrics,
                                            parameters: EvaluationParameters) -> Mse {
        let percentValue: Double = parameters.percentValue ? 100 : 1
        if parameters.normalized {
            let trainMse = regressor.trainingMetrics.rootMeanSquaredError
            let validationMse = regressor.validationMetrics.rootMeanSquaredError
            let trainDiff = abs(shuffled.rootMeanSquaredError - trainMse) * percentValue
            let validateDiff = abs(shuffled.rootMeanSquaredError - validationMse) * percentValue
            return Mse(feature: feature, train: trainDiff, validate: validateDiff)
        } else {
            let mse = shuffled.rootMeanSquaredError * percentValue
            return Mse(feature: feature,
                       train: mse,
                       validate: mse)
        }
    }
    
    private static func shuffle(columnName: String, for df: DataFrame) -> DataFrame {
        logger.info("shuffling column name: \(columnName)")
        let shuffled = df[columnName].shuffled()
        var mutableCopy = df
        for index in 0..<shuffled.count {
            mutableCopy[columnName][index] = shuffled[index]
        }
        return mutableCopy
    }
}
