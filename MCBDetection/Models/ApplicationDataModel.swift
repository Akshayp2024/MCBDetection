
import Foundation

struct application: Codable {
    let id: Int
    let applicationName: String
    let image: String
}

struct sampleApplication: Codable {
    let applications: [application]
}


func readLocalJSONFile(forName name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        }
    } catch {
        print("error: \(error)")
    }
    return nil
}

func parse(jsonData: Data) -> sampleApplication? {
    do {
        let decodedData = try JSONDecoder().decode(sampleApplication.self, from: jsonData)
        return decodedData
    } catch {
        print("error: \(error)")
    }
    return nil
}


