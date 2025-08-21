import Foundation
import SwiftData

@Model
class CategoryModel {
    @Attribute(.unique) var id: Int
    var name: String
    var emoji: String
    var isIncome: Bool

    var direction: Direction {
        isIncome ? .income : .outcome
    }
    
    @Relationship(deleteRule: .cascade, inverse: \TransactionModel.category)
    var transactions: [TransactionModel] = []

    init(id: Int, name: String, emoji: String, isIncome: Bool) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isIncome = isIncome
    }
}

extension Category {
    init(model: CategoryModel) {
        self.id = model.id
        self.name = model.name
        self.emoji = Character(model.emoji)
        self.isIncome = model.isIncome
    }
}

extension CategoryModel {
    convenience init(category: Category) {
        self.init(id: category.id, name: category.name, emoji: category.emoji.description, isIncome: category.isIncome)
    }
}
