//  NQ Detect
//
//  Created by NULL on 10/9/22.
//

import AVFoundation
import Vision
import CoreImage
import SwiftUI

class ObjectDetection: ObservableObject {
    
    @Published var row1Labels: [[String]] = []
    @Published var mcbDetailsArray: [[MCBDetails]] = []
    var row2Labels: [String] = []
    @ObservedObject var vm = ViewModel()
    var detectionRequest:VNCoreMLRequest!
    var ready = false
    
    init(vm: ViewModel){
        self.vm = vm
        Task { self.initDetection() }
        
    }
    
    func initDetection(){
        do {
            let model = try VNCoreMLModel(for: best(configuration: MLModelConfiguration()).model)
            
            self.detectionRequest = VNCoreMLRequest(model: model)
            
            self.ready = true
            
        } catch let error {
            fatalError("failed to setup model: \(error)")
        }
    }
    
    func detectAndProcess(image:CIImage)-> ([[String]], [[MCBDetails]]){
        
        let observations = self.detect(image: image)
        
        let processedObservations = self.processObservation(observations: observations, viewSize: image.extent.size)
        print("processedObservations",processedObservations)
    
        // print(sortedY1)
        let sortedY1 = processedObservations.sorted(by: {$0.boundingBox.minY < $1.boundingBox.minY})
        // print("Sorted Dictionary",sortedY1)
        var rows: [[ProcessedObservation]] = []
        var currentRow: [ProcessedObservation] = []
        let threshold: Double = 30.0
        for i in 0..<sortedY1.count {
            if currentRow.isEmpty {
                currentRow.append(sortedY1[i])
            } else {
                let yDiff = sortedY1[i].boundingBox.minY - currentRow.last!.boundingBox.minY
                if yDiff < threshold {
                    currentRow.append(sortedY1[i])
                } else {
                    currentRow.reverse()
                    rows.append(currentRow)
                    currentRow = [sortedY1[i]]
                    
                }
            }
        }
        if !currentRow.isEmpty {
            var sortedRow =  currentRow.sorted(by: {$0.boundingBox.minX > $1.boundingBox.minX})
            sortedRow.reverse()
            rows.append(sortedRow)
        }
        
        let finalRows: [[String]] = rows.map { row in
            return row.map { box in
                return box.label
            }
        }
        
        row1Labels = finalRows
        print(row1Labels)
        vm.classification1 = row1Labels
        for (index, labelArray) in row1Labels.enumerated() {
            var arrayOfMCB: [MCBDetails] = []
            for label in labelArray {
                arrayOfMCB.append(vm.all(rowNumber: index, referenceNumber: label))
            }
            mcbDetailsArray.append(arrayOfMCB)
        }
        
        vm.classification = mcbDetailsArray
        print("vm.classification: \(vm.classification)")
        print("vm.classification1: \(vm.classification1)")
        return (row1Labels, mcbDetailsArray)
    }
    
    
    func detect(image:CIImage) -> [VNObservation]{
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([self.detectionRequest])
            let observations = self.detectionRequest.results!
            
            return observations
            
        }catch let error{
            fatalError("failed to detect: \(error)")
        }
        
    }
    
    
    func processObservation(observations:[VNObservation], viewSize:CGSize) -> [ProcessedObservation]{
        
        var processedObservations:[ProcessedObservation] = []
        
        for observation in observations where observation is VNRecognizedObjectObservation {
            
            let objectObservation = observation as! VNRecognizedObjectObservation
            
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(viewSize.width), Int(viewSize.height))
            
            let flippedBox = CGRect(x: objectBounds.minX, y: viewSize.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            // print("FlippedBox Row",flippedBox.minX)
            // print("FlippedBox column",flippedBox.minY)
            let label = objectObservation.labels.first!.identifier
            //print("Label",label)
            let processedOD = ProcessedObservation(label: label, confidence: objectObservation.confidence, boundingBox: flippedBox)
            
            processedObservations.append(processedOD)
        }
        
        
        return processedObservations
        
    }
    
}

struct ProcessedObservation{
    var label: String
    var confidence: Float
    var boundingBox: CGRect
}
