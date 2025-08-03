
final class CategoriesService {
    private let client: NetworkClient

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }

    func getCategories() async throws -> [CategoryResponse] {
        let categories = try await client.request(endpoint: "categories", method: .get, responseType: [CategoryResponse].self)
        return categories
    }

    func getCategories(direction: Direction) async throws -> [CategoryResponse] {
        let allCategories = try await getCategories()
        return allCategories.filter { $0.isIncome == (direction == .income) }
    }
}
