import Foundation

enum ProjectError: Error {
    case saveFailed
    case loadFailed
    case fileNotFound
}

class ProjectManager {
    static let shared = ProjectManager()
    
    private init() {}
    
    func saveProject(_ project: Project, to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(project)
        try data.write(to: url)
    }
    
    func loadProject(from url: URL) throws -> Project {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Project.self, from: data)
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
} 