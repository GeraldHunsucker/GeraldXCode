import Foundation

enum HomeDepotAPIError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case apiError(String)
    case rateLimitExceeded
}

struct HomeDepotAPI {
    private static let baseURL = "https://api.homedepot.com/v2"
    private static let apiKey = "YOUR_API_KEY"  // Get this from Home Depot Developer Portal
    private static let storeId = "STORE_ID"     // Local store ID
    
    static func searchProduct(query: String) async throws -> [HomeDepotProduct] {
        var components = URLComponents(string: "\(baseURL)/products/search")
        components?.queryItems = [
            URLQueryItem(name: "keyword", value: query),
            URLQueryItem(name: "storeId", value: storeId),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components?.url else {
            throw HomeDepotAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HomeDepotAPIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            return try decoder.decode(HomeDepotSearchResponse.self, from: data).products
        case 429:
            throw HomeDepotAPIError.rateLimitExceeded
        default:
            throw HomeDepotAPIError.apiError("Status code: \(httpResponse.statusCode)")
        }
    }
    
    static func getProductDetails(productId: String) async throws -> HomeDepotProduct {
        var components = URLComponents(string: "\(baseURL)/products/\(productId)")
        components?.queryItems = [
            URLQueryItem(name: "storeId", value: storeId),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components?.url else {
            throw HomeDepotAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HomeDepotAPIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            return try decoder.decode(HomeDepotProduct.self, from: data)
        case 429:
            throw HomeDepotAPIError.rateLimitExceeded
        default:
            throw HomeDepotAPIError.apiError("Status code: \(httpResponse.statusCode)")
        }
    }
}

struct HomeDepotProduct: Codable {
    let productId: String
    let name: String
    let price: HomeDepotPrice
    let dimensions: HomeDepotDimensions?
    let inventory: HomeDepotInventory
}

struct HomeDepotPrice: Codable {
    let value: Double
    let currency: String
}

struct HomeDepotDimensions: Codable {
    let length: Double
    let width: Double
    let thickness: Double
    let unit: String
}

struct HomeDepotInventory: Codable {
    let quantity: Int
    let stockLevel: String
}

struct HomeDepotSearchResponse: Codable {
    let products: [HomeDepotProduct]
} 