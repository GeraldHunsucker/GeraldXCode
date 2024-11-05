import Foundation

enum PriceSource {
    case homedepot
    case lowes
    case menards
    // Add more sources as needed
}

actor MaterialPriceService {
    static let shared = MaterialPriceService()
    private var priceCache: [String: (price: Double, timestamp: Date)] = [:]
    private let cacheValidityDuration: TimeInterval = 24 * 60 * 60 // 24 hours
    
    private init() {}
    
    func getCurrentPrice(for material: Material, source: PriceSource = .homedepot) async throws -> Double {
        // Check cache first
        if let cached = priceCache[material.name],
           Date().timeIntervalSince(cached.timestamp) < cacheValidityDuration {
            return cached.price
        }
        
        // If not in cache or cache expired, fetch new price
        let price = try await fetchPrice(for: material, from: source)
        priceCache[material.name] = (price, Date())
        return price
    }
    
    private func fetchPrice(for material: Material, from source: PriceSource) async throws -> Double {
        switch source {
        case .homedepot:
            // Construct search query based on material properties
            let searchQuery = constructSearchQuery(for: material)
            let products = try await HomeDepotAPI.searchProduct(query: searchQuery)
            
            // Find best matching product
            guard let bestMatch = findBestMatch(products: products, material: material) else {
                throw PriceError.noMatchingProducts
            }
            
            // Get detailed product info
            let details = try await HomeDepotAPI.getProductDetails(productId: bestMatch.productId)
            return details.price.value
            
        case .lowes, .menards:
            // Implement other sources later
            throw PriceError.sourceNotImplemented
        }
    }
    
    private func constructSearchQuery(for material: Material) -> String {
        var query = material.name
        
        // Add dimensions to search
        let lengthFeet = material.length / 12
        let widthFeet = material.width / 12
        query += " \(Int(lengthFeet))x\(Int(widthFeet))"
        
        return query
    }
    
    private func findBestMatch(products: [HomeDepotProduct], material: Material) -> HomeDepotProduct? {
        // Score each product based on how well it matches our requirements
        let scoredProducts = products.map { product -> (product: HomeDepotProduct, score: Int) in
            var score = 0
            
            // Check dimensions if available
            if let dimensions = product.dimensions {
                // Convert all to inches for comparison
                let lengthMatch = abs(dimensions.length - material.length) < 1
                let widthMatch = abs(dimensions.width - material.width) < 1
                
                if lengthMatch { score += 3 }
                if widthMatch { score += 3 }
            }
            
            // Check name similarity
            if product.name.lowercased().contains(material.name.lowercased()) {
                score += 2
            }
            
            // Check inventory
            if product.inventory.quantity > 0 {
                score += 1
            }
            
            return (product, score)
        }
        
        // Return the product with the highest score
        return scoredProducts
            .sorted { $0.score > $1.score }
            .first?
            .product
    }
}

enum PriceError: Error {
    case noMatchingProducts
    case sourceNotImplemented
} 