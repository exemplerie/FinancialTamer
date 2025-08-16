import Foundation

protocol CategoriesServiceProtocol {
    func getCategories() async throws -> [Category]
    func getCategories(direction: Direction) async throws -> [Category]
}
