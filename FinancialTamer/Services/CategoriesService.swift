
final class CategoriesService {
    private let mockData: [Category] = [
        Category(id: 1, name: "Получка", emoji: "💵", isIncome: true),
        Category(id: 2, name: "На покушать", emoji: "🍕", isIncome: false),
        Category(id: 3, name: "На собаку", emoji: "🐶", isIncome: false)
    ]

    func allCategories() async throws -> [Category] {
        return mockData
    }

    func getIncomeOrOutcome(direction: Direction) async throws -> [Category] {
        return mockData.filter { $0.direction == direction }
    }
}
