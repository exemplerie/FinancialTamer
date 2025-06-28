import SwiftUI

struct ShakeDetector: UIViewControllerRepresentable {
    let onShake: () -> Void
    
    func makeUIViewController(context: Context) -> DetectorViewController {
        let controller = DetectorViewController()
        controller.onShake = onShake
        return controller
    }
    
    func updateUIViewController(_ uiViewController: DetectorViewController, context: Context) {}
}

class DetectorViewController: UIViewController {
    var onShake: (() -> Void)?
    
    override var canBecomeFirstResponder: Bool { true }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        onShake?()
    }
}

