import SwiftUI
import UIKit

struct AnalysisScreen: View {
    var body: some View {
        AnalysisScreenRepresentable()
            .navigationTitle("Анализ")
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct AnalysisScreenRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AnalysisViewController {
        AnalysisViewController()
    }
    
    func updateUIViewController(_ uiViewController: AnalysisViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        var parent: AnalysisScreenRepresentable
        
        init(_ parent: AnalysisScreenRepresentable) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


#Preview {
    AnalysisScreen()
}
