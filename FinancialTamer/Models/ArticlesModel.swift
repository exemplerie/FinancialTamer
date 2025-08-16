import SwiftUI

@Observable
final class ArticlesModel {
    let service = FallbackCategoriesService()
    
    var allCategories: [Category] = []
    
    var filteredCategories: [Category] {
        guard !searchedText.isEmpty else {
            return allCategories
        }
        let query = searchedText.lowercased()
        return allCategories
            .map { category -> (Category, Double) in
                let name = category.name.lowercased()
                let isSubstring = name.contains(query)
                let score = isSubstring ? 1.0 : fuzzyMatchScore(query, name)
                return (category, score)
            }
            .filter { _, score in score > 0.3 }
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
    }
    
    var searchedText = ""
    
    func loadCategories() async throws {
        allCategories = try await service.getCategories()
    }
    
    private func fuzzyMatchScore(_ a: String, _ b: String) -> Double {
        let distance = levenshtein(a, b)
        let maxLength = max(a.count, b.count)
        guard maxLength > 0 else { return 0 }
        return 1.0 - (Double(distance) / Double(maxLength))
    }
    
    private func levenshtein(_ a: String, _ b: String) -> Int {
        let a = Array(a)
        let b = Array(b)
        var matrix = Array(repeating: Array(repeating: 0, count: b.count + 1), count: a.count + 1)
        
        for i in 0...a.count { matrix[i][0] = i }
        for j in 0...b.count { matrix[0][j] = j }
        
        for i in 1...a.count {
            for j in 1...b.count {
                if a[i - 1] == b[j - 1] {
                    matrix[i][j] = matrix[i - 1][j - 1]
                } else {
                    matrix[i][j] = min(
                        matrix[i - 1][j] + 1,
                        matrix[i][j - 1] + 1,
                        matrix[i - 1][j - 1] + 1
                    )
                }
            }
        }
        return matrix[a.count][b.count]
    }
}
