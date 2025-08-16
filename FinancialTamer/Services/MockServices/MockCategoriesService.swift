
final class MockCategoriesService: CategoriesServiceProtocol {
    private let mockData: [Category] = [
        Category(id: 1, name: "Получка", emoji: "💵", isIncome: true),
        Category(id: 2, name: "На покушать", emoji: "🍕", isIncome: false),
        Category(id: 3, name: "На собаку", emoji: "🐶", isIncome: false),
        Category(id: 4, name: "Здоровье", emoji: "💊", isIncome: false),
        Category(id: 5, name: "Подарок", emoji: "🎁", isIncome: true)
    ]

    func getCategories() async throws -> [Category] {
        return mockData
    }

    func getCategories(direction: Direction) async throws -> [Category] {
        return mockData.filter { $0.direction == direction }
    }
}
