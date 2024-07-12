//
//  MCBDetails.swift
//  MCBModel
//
//  Created by Ayesha Siddiqua on 20/02/24.
//

import Foundation
import SwiftUI

//struct MCBDetails: Identifiable, Equatable, Hashable {
//    var id = UUID()
//    var logo: String = ""
//    var name: String = ""
//    var areaName: String = ""
//    var referenceNumber: String = ""
//    
//    init(id: UUID = UUID(), logo: String, name: String, areaName: String, referenceNumber: String) {
//        self.id = id
//        self.logo = logo
//        self.name = name
//        self.areaName = areaName
//        self.referenceNumber = referenceNumber
//    }
//}

class MCBDetails: ObservableObject, Identifiable, Equatable {
    var id = UUID()
    var logo: String = ""
    var name: String = ""
    var areaName: String = ""
    var referenceNumber: String = ""
    
    init(id: UUID = UUID(), logo: String, name: String, areaName: String, referenceNumber: String) {
        self.id = id
        self.logo = logo
        self.name = name
        self.areaName = areaName
        self.referenceNumber = referenceNumber
    }
    
    static func == (lhs: MCBDetails, rhs: MCBDetails) -> Bool {
        false
    }
}


//extension MCBDetails {
//    
//    static func all() -> [MCBDetails] {
//        return [
//            MCBDetails(logo:  "lightswitch.on", name: "SPD Switch", areaName: "Kitchen",referenceNumber: ""),
//            MCBDetails(logo: "lightbulb", name: "Light", areaName: "Hall", referenceNumber: ""),
//            MCBDetails(logo: "air.conditioner.horizontal", name: "Air Conditioner", areaName: "Bedroom",referenceNumber: ""),
//            MCBDetails(logo: "lightswitch.on", name: "Socket", areaName: "Utility",referenceNumber: "")
//            
//        ]
//    }
//}
    /*
    static func all1() -> [MCBDetails] {
        return [
            MCBDetails(logo:  "lightbulb", name: "Baking", areaName: "Kitchen"),
            MCBDetails(logo: "lightbulb", name: "Gas", areaName: "Hall"),
            MCBDetails(logo: "air.conditioner.horizontal", name: "Water Heater", areaName: "Bedroom"),
            MCBDetails(logo: "lightswitch.on", name: "Switch", areaName: "Utility"),
            MCBDetails(logo: "lightbulb", name: "Socket", areaName: "Utility"),
            MCBDetails(logo: "lightbulb", name: "Light", areaName: "Utility")
        ]
    }
    
    static func all2() -> [MCBDetails] {
        return [
            MCBDetails(logo:  "lightbulb", name: "Light", areaName: "Kitchen"),
            MCBDetails(logo: "alarm.fill", name: "Alarm", areaName: "Hall"),
            MCBDetails(logo: "folder", name: "Motor", areaName: "Bedroom"),
            MCBDetails(logo: "lightswitch.on", name: "Smart Switch", areaName: "Utility"),
            MCBDetails(logo: "lightbulb", name: "Socket", areaName: "Utility")
        ]
    }
    
    
//    static var get: MCBDetails {
//      
//        return  MCBDetails(logo:  "lightbulb", name: "Light", areaName: "Kitchen");
//        
//    }
}
*/
