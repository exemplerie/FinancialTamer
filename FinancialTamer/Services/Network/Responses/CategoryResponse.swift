struct CategoryResponse: Decodable {
    let id: Int
    let name: String
    let emoji: String
    let isIncome: Bool
}

extension Category {
    init(response: CategoryResponse) {
        self.id = response.id
        self.name = response.name
        self.emoji = Character(response.emoji)
        self.isIncome = response.isIncome
    }
}
