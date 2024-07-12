
import Foundation

class ApplicationViewModel: ObservableObject {
    
    @Published var applicationArray : [application] = []
    @Published var selectedApplication : application?

    init() {
        parseApplication()
    }
    
    func parseApplication() {
        
        let jsonData = readLocalJSONFile(forName: "Application")
        if let data = jsonData {
            if let sampleApplicationdObj = parse(jsonData: data) {
                for application in sampleApplicationdObj.applications {
                    applicationArray.append(application)
                }
            }
        }
    }
}
