
final class NetworkCategoriesService: CategoriesServiceProtocol {
    private let client: NetworkClient

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }

    func getCategories() async throws -> [Category] {
        let categories = try await client.request(endpoint: "categories", method: .get, responseType: [CategoryResponse].self)
        return categories.compactMap { Category(response: $0) }
    }

    func getCategories(direction: Direction) async throws -> [Category] {
        let allCategories = try await getCategories()
        return allCategories.filter { $0.isIncome == (direction == .income) }
    }
}
