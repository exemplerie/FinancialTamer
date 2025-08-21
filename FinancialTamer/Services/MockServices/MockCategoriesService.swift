
final class MockCategoriesService: CategoriesServiceProtocol {
    private let mockData: [Category] = [
        Category(id: 0, name: "Аренда квартиры", emoji: "🏠", isIncome: false),
        Category(id: 1, name: "Одежда", emoji: "👗", isIncome: false),
        Category(id: 2, name: "На собачку", emoji: "🐶", isIncome: false),
        Category(id: 3, name: "Ремонт квартиры", emoji: "🔨", isIncome: false),
        Category(id: 4, name: "Продукты", emoji: "🍕", isIncome: false),
        Category(id: 5, name: "Спортзал", emoji: "🏋️‍♂️", isIncome: false),
        Category(id: 6, name: "Медицина", emoji: "❤️‍🩹", isIncome: false),
        Category(id: 7, name: "Аптека", emoji: "💊", isIncome: false),
        Category(id: 8, name: "Машина", emoji: "🚗", isIncome: false),
        Category(id: 9, name: "Зарплата", emoji: "💵", isIncome: true),
        Category(id: 10, name: "Подарок", emoji: "🎁", isIncome: true),
        Category(id: 11, name: "Фриланс", emoji: "🧑‍💻", isIncome: true),
        
    ]

    func getCategories() async throws -> [Category] {
        return mockData
    }

    func getCategories(direction: Direction) async throws -> [Category] {
        return mockData.filter { $0.direction == direction }
    }
}
