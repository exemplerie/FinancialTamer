import SwiftUI

struct ArticlesScreen: View {
    @State var articlesModel = ArticlesModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Статьи")) {
                    if articlesModel.filteredCategories.isEmpty {
                        Text("Категорий не найдено.")
                    } else {
                        ForEach(articlesModel.filteredCategories, id: \.id) { category in
                            ArtcicleCell(emoji: category.emoji, categoryName: category.name)
                        }
                    }
                }
            }
            .searchable(text: $articlesModel.searchedText)
            .navigationTitle("Мои статьи")
            .task {
                do {
                    try await articlesModel.loadCategories()
                } catch {
                    print("Error in categories loading: \(error)")
                }
            }
            .offset(y: -15)
        }
        .tint(.element)
    }
}

struct ArtcicleCell: View {
    var emoji: Character
    var categoryName: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 24, height: 24)
                Text(emoji.description)
                    .font(.system(size: 13))
            }
            
            Text(categoryName).font(.body)
        }
        
    }
}

#Preview {
    ArticlesScreen()
}
