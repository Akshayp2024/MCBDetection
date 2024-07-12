//
//  Date+Extension.swift
//  MCBDetection
//
//  Created by Akshay Suresh Patil on 21/06/24.
//

import Foundation

extension Date {
    func getFormattedTimeString(outPutDateFormate: String, date: Date) -> String? {

        let dateformat = DateFormatter()
        dateformat.dateFormat = outPutDateFormate
        guard let dateString = dateformat.string(from: date) as? String else {
            return ""
        }
        return dateString
    }
    
    
}

extension String {
    static let ddMMYYYY = "dd/MM/yyyy"
}
