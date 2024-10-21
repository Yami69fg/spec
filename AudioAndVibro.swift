import UIKit
import SpriteKit
import AVFoundation

extension UIViewController {
    
    func addButtonSoundEffectOnTouchDown(uiButton: UIButton) {
        uiButton.addTarget(self, action: #selector(handleButtonTouchDown(sender:)), for: .touchDown)
    }
    
    @objc private func handleButtonTouchDown(sender: UIButton) {
        AudioAndVibrokManager.shared.playSoundPress()
    }
}

class AudioAndVibrokManager {
    
    static let shared = AudioAndVibrokManager()
    private var audio: AVAudioPlayer?

    private init() {}
    
    func playSoundPress() {
        let isSoundEnabled = UserDefaults.standard.bool(forKey: "isSoundTrue")
        if isSoundEnabled {
            guard let sound = Bundle.main.url(forResource: "audioPress", withExtension: "wav") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
        
        let isVibrationEnabled = UserDefaults.standard.bool(forKey: "isVibroTrue")
        if isVibrationEnabled {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
        }
    }
}
