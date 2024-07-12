//
//  ViewModel.swift
//  MCBDetection
//
//  Created by Ayesha Siddiqua on 14/02/24.
//

import SwiftUI
import Vision
import CoreML


class ViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var isImageUploaded = false
    @Published var source: PickerSource.Source = .library

    @Published var isMCBProcesed = false

    @Published var classification1: [[String]] = []
    @Published var classification: [[MCBDetails]] = []
    @Published var mcbDetails : [MCBDetails] = []
    @Published var rowCountUUID: [String] = []
   
    @Published var showEmptyRowSheet = false

    var arrayOfmcbDetailsDic: [Int: [MCBDetails]] = [:]

    @Published var applicationViewModel = ApplicationViewModel()

    @Published var index = 0
    @Published var scrollStaticId = ""
    @Published var endOfScroll = false
    @Published var shouldNavigateToRowDetails = false
    @Published var slectedRow = 0
    @Published var selectedIndex = 0
    @Published var showBackgroundImage = false
    @Published var editList = false
    @Published var endOfVerticalScroll = false
    @Published var verticalScrollIndex = 0
    
    let logos = ["air.conditioner.horizontal", "air.purifier", "lightbulb.max", "oven", "lightswitch.on.square", "dryer", "dishwasher"]
    let applicationNames = [ "Cooler","Geyser","Lighting", "Baking oven", "SPD switch", "Machine", "Dishwasher"]
    let areaNames = ["Hall", "Bedroom", "Kitchen", "Utility", "Corridor", "Terrace"]
    
    
    func all(rowNumber: Int, referenceNumber: String) -> MCBDetails {
        
        let keyToUpdate = rowNumber
        let application = self.applicationViewModel.applicationArray.randomElement()
        let item = MCBDetails(logo:  application?.image ?? self.logos.randomElement()!,
                              name: application?.applicationName ?? self.applicationNames.randomElement()!,
                              areaName: self.areaNames.randomElement()!,
                              referenceNumber: referenceNumber)
        
        if var arrayToUpdate = arrayOfmcbDetailsDic[rowNumber] {
            
            arrayToUpdate.append(item)
            arrayOfmcbDetailsDic[keyToUpdate] = arrayToUpdate
        }
        else {
           
               arrayOfmcbDetailsDic[keyToUpdate] = [item]
            print("&&&&&&&&&&&&&&&&&&&\(arrayOfmcbDetailsDic)")
            
        }
        
       // print("***** row\(rowNumber) Referencenumber \(referenceNumber)")
       // print(arrayOfmcbDetailsDic)
        return item
            
    }
    
    func all(referenceNumber: String) -> MCBDetails {
        
        let application = self.applicationViewModel.applicationArray.randomElement()
        let item = MCBDetails(logo:  application?.image ?? self.logos.randomElement()!,
                              name: application?.applicationName ?? self.applicationNames.randomElement()!,
                              areaName: self.areaNames.randomElement()!,
                              referenceNumber: referenceNumber)
        return item
    }
    
}
