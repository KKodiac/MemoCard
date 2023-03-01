//
//  TextRecognizerViewModel.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/20.
//

import Vision
import os

private let logger = Logger(subsystem: "com.seanhong.KKodiac.MemoCard", category: "OCRService")

final class OCRService: ObservableObject {
    private var results: [VNRecognizedTextObservation]?
    private var requestHandler: VNImageRequestHandler?
    private var textRecognitionRequest: VNRecognizeTextRequest!
    private var recognizedContent: [String] = []
    
    internal func performTextRecognition(with data: Data, as recognitionLevel: VNRequestTextRecognitionLevel) -> [String] {
        textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let results = request.results as? [VNRecognizedTextObservation] else {
                logger.error("[Vision]: Unexpected type of text observation.")
                return
            }
            self.results = results
        }
        textRecognitionRequest.recognitionLevel = recognitionLevel
        textRecognitionRequest.recognitionLanguages = ["ko-KR", "en-US"]
        requestHandler = VNImageRequestHandler(data: data, options: [:])
        do {
            try requestHandler?.perform([textRecognitionRequest])
        } catch {
            logger.error("[Vision]: Unable to perform request.")
        }
        
        logger.log("[CameraService]: Text recognition completed.")
        self.results?.forEach {
            $0.topCandidates(1).forEach { candidate in
                recognizedContent.append(candidate.string)
                logger.log("[Vision]: Number of VNRecognized texts: \(candidate.string)")
            }
        }
        
        return recognizedContent
    }
}
