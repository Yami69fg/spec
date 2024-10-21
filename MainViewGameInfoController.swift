import UIKit
import SpriteKit
import GameplayKit
import AVFAudio

class MainViewGameInfoController: UIViewController {
    weak var sceneGame: Spectacular?
    
    var playerAudio: AVAudioPlayer?
    
    var backMenuControllerClosure: (() -> ())?
    var backToGameClosure: (() -> ())?
    
    var selectedLevelIndex = 0
    
    private let gameLevelConfigurationsArray: [GameLevelConfiguration] = [
        GameLevelConfiguration(requiredTargetLevelScore: 10,dificultLevel: 1),
        GameLevelConfiguration(requiredTargetLevelScore: 20,dificultLevel: 1),
        GameLevelConfiguration(requiredTargetLevelScore: 30,dificultLevel: 1),
        GameLevelConfiguration(requiredTargetLevelScore: 40,dificultLevel: 1),
        GameLevelConfiguration(requiredTargetLevelScore: 10,dificultLevel: 2),
        GameLevelConfiguration(requiredTargetLevelScore: 20,dificultLevel: 2),
        GameLevelConfiguration(requiredTargetLevelScore: 30,dificultLevel: 2),
        GameLevelConfiguration(requiredTargetLevelScore: 40,dificultLevel: 2),
        GameLevelConfiguration(requiredTargetLevelScore: 10,dificultLevel: 3),
        GameLevelConfiguration(requiredTargetLevelScore: 20,dificultLevel: 3),
        GameLevelConfiguration(requiredTargetLevelScore: 30,dificultLevel: 3),
        GameLevelConfiguration(requiredTargetLevelScore: 40,dificultLevel: 3)
    ]


    
    private let audioSettingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "SettingAudioButtonImage"), for: .normal)
        return button
    }()
    
    private let backgroundImageForGlobalScore: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "BackGroundForBalance"))
        return imageView
    }()
    
    private let globalScoreDisplayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Questrian", size: 18)
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    private let ballCounterBackgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "MainMenuBall"))
        return imageView
    }()
    
    private let ballCounterDisplayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Questrian", size: 32)
        label.textAlignment = .center
        label.text = "x5"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: view.frame)
        
        if let viewGame = self.view as? SKView {
            let openSpectacularGame = Spectacular(size: viewGame.bounds.size)
            self.sceneGame = openSpectacularGame
            openSpectacularGame.mainViewGameInfoController = self
            openSpectacularGame.targetLevelScore = gameLevelConfigurationsArray[selectedLevelIndex].requiredTargetLevelScore
            openSpectacularGame.dificultLevel = gameLevelConfigurationsArray[selectedLevelIndex].dificultLevel
            openSpectacularGame.scaleMode = .aspectFill
            viewGame.presentScene(openSpectacularGame)
        }
        
        addAudioSettingsButton()
        setupBackgroundImageForGlobalScore()
        setupBallCounterBackgroundImage()
    }
    
    func addAudioSettingsButton() {
        view.addSubview(audioSettingsButton)
        audioSettingsButton.layer.zPosition = 10

        audioSettingsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(60)
            make.height.width.equalTo(60)
        }
        
        audioSettingsButton.addTarget(self, action: #selector(openAudioSettingsController), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: audioSettingsButton)
    }

    func setupBackgroundImageForGlobalScore() {
        view.addSubview(backgroundImageForGlobalScore)
        backgroundImageForGlobalScore.layer.zPosition = 10

        backgroundImageForGlobalScore.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
            make.height.equalTo(40)
            make.width.equalTo(175)
        }
        
        backgroundImageForGlobalScore.addSubview(globalScoreDisplayLabel)
        globalScoreDisplayLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupBallCounterBackgroundImage() {
        view.addSubview(ballCounterBackgroundImage)
        ballCounterBackgroundImage.layer.zPosition = 10

        ballCounterBackgroundImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(60)
            make.height.width.equalTo(60)
        }
        
        ballCounterBackgroundImage.addSubview(ballCounterDisplayLabel)
        ballCounterDisplayLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func openAudioSettingsController() {
        let openAudioSettingsController = OpenSettingAudioController()
        sceneGame?.pauseGameSceneFunction()
        openAudioSettingsController.backMenuController = { [weak self] in
            self?.dismiss(animated: false)
            self?.backMenuControllerClosure?()
        }
        openAudioSettingsController.backToGame = { [weak self] in
            self?.sceneGame?.resumeGameSceneFunction()
        }
        openAudioSettingsController.modalPresentationStyle = .overCurrentContext
        self.present(openAudioSettingsController, animated: true, completion: nil)
    }

    func updateBallCounterDisplay(newBallCount: Int) {
        ballCounterDisplayLabel.text = "x\(newBallCount)"
    }

    func saveGlobalScoreToUserDefaults(_ score: Int) {
        UserDefaults.standard.set(score, forKey: "GlobalScore")
    }

    private func loadGlobalScoreFromUserDefaults() -> Int {
        return UserDefaults.standard.integer(forKey: "GlobalScore")
    }
    
    func updateGlobalScoreDisplay(_ newGlobalScore: Int) {
        globalScoreDisplayLabel.text = "\(newGlobalScore)"
    }
    
    func updateLevelCompletedListForGame() {
        var levelCompletionStatesForAllLevels = UserDefaults.standard.array(forKey: "completedLevels") as? [Bool] ?? Array(repeating: false, count: 12)
        
        if selectedLevelIndex < levelCompletionStatesForAllLevels.count {
            levelCompletionStatesForAllLevels[selectedLevelIndex] = true
            if selectedLevelIndex + 1 < levelCompletionStatesForAllLevels.count {
                levelCompletionStatesForAllLevels[selectedLevelIndex + 1] = true
            }
            UserDefaults.standard.set(levelCompletionStatesForAllLevels, forKey: "completedLevels")
        }
    }
    
    func playTheEnd() {
        if  UserDefaults.standard.bool(forKey: "isSoundTrue") {
            guard let url = Bundle.main.url(forResource: "theEnd", withExtension: "wav") else {
                return
            }
            do {
                playerAudio = try AVAudioPlayer(contentsOf: url)
                playerAudio?.play()
            } catch {
            }
        }
    }
    
    func processGameCompletionAndGameOverScreen(currentGameScoreValue:Int,endImageViewForOverGame:String) {
        sceneGame?.pauseGameSceneFunction()

        if endImageViewForOverGame == "YouWinLabelImage" {
            updateLevelCompletedListForGame()
        }
        let gameOverSpecController = GameOverSpectacularScene()
        playTheEnd()
        gameOverSpecController.backMenuController = { [weak self] in
            self?.dismiss(animated: false)
            self?.backMenuControllerClosure?()
        }
        gameOverSpecController.restartGame = { [weak self] in
            self?.sceneGame?.restartGameSceneFunction()
        }
        
        gameOverSpecController.currentGameScoreValue = currentGameScoreValue
        gameOverSpecController.endImageViewForOverGame = endImageViewForOverGame
        gameOverSpecController.modalPresentationStyle = .overCurrentContext
        self.present(gameOverSpecController, animated: true)
    }

}

struct GameLevelConfiguration {
    let requiredTargetLevelScore: Int
    let dificultLevel: Int
}
