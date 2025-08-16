final class FallbackCategoriesService: CategoriesServiceProtocol {
    private let primary: CategoriesServiceProtocol
    private let fallback: CategoriesServiceProtocol
    private var isUsingFallback = true
    
    init(primary: CategoriesServiceProtocol = NetworkCategoriesService(), fallback: CategoriesServiceProtocol = MockCategoriesService()) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func getCategories() async throws -> [Category] {
        if isUsingFallback {
            return try await fallback.getCategories()
        }
        do {
            return try await primary.getCategories()
        } catch {
            isUsingFallback = true
            return try await fallback.getCategories()
        }
    }
    
    func getCategories(direction: Direction) async throws -> [Category] {
        if isUsingFallback {
            return try await fallback.getCategories(direction: direction)
        }
        do {
            return try await primary.getCategories(direction: direction)
        } catch {
            isUsingFallback = true
            return try await fallback.getCategories(direction: direction)
        }
    }
}

