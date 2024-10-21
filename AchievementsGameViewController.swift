import UIKit
import SnapKit

class AchievementsGameViewController: UIViewController {

    private let fullScreenBackgroundImageViewForAllGameControllers: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "BackGroundForAllControllers")
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()
    
    private let globalScoreDisplayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Questrian", size: 18)
        label.textAlignment = .center
        label.text = String(UserDefaults.standard.integer(forKey: "GlobalScore"))
        return label
    }()
    
    private let backgroundImageForGlobalScore: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "BackGroundForBalance"))
        return imageView
    }()

    private let closeButtonForExitingLevelSelectionView: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "CloseButtonImage"), for: .normal)
        return button
    }()

    private let scoreAchievementButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ScoreAchive"), for: .normal)
        return button
    }()

    private let levelsAchievementButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "LevelAchive"), for: .normal)
        return button
    }()

    private let goalsAchievementButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "BallsAchive"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        closeButtonForExitingLevelSelectionView.addTarget(self, action: #selector(closeLevelSelectionView), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: closeButtonForExitingLevelSelectionView)
        
        setupMainGameLevelsViewControllerLayout()
        setupCloseButton()
        setupBackgroundImageForGlobalScore()
        setupAchievementButtons()
        checkAchievements()
    }
    
    private func setupAchievementButtons() {
        view.addSubview(scoreAchievementButton)
        view.addSubview(levelsAchievementButton)
        view.addSubview(goalsAchievementButton)

        scoreAchievementButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.7)
        }

        levelsAchievementButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scoreAchievementButton.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.7)
        }

        goalsAchievementButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(levelsAchievementButton.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.7)
        }

        scoreAchievementButton.addTarget(self, action: #selector(checkScoreAchievement), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: scoreAchievementButton)
        levelsAchievementButton.addTarget(self, action: #selector(checkLevelsAchievement), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: levelsAchievementButton)
        goalsAchievementButton.addTarget(self, action: #selector(checkGoalsAchievement), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: goalsAchievementButton)
    }

    private func checkAchievements() {
        let globalScore = UserDefaults.standard.integer(forKey: "GlobalScore")
        if globalScore >= 1000 {
            scoreAchievementButton.alpha = 1.0
        } else {
            scoreAchievementButton.alpha = 0.5
        }

        let completedLevels = UserDefaults.standard.array(forKey: "completedLevels") as? [Bool] ?? []
        let completedCount = completedLevels.filter { $0 == true }.count
        if completedCount >= 6 {
            levelsAchievementButton.alpha = 1.0
        } else {
            levelsAchievementButton.alpha = 0.5
        }

        if globalScore/10 >= 20 {
            goalsAchievementButton.alpha = 1.0
        } else {
            goalsAchievementButton.alpha = 0.5
        }
    }

    @objc private func checkScoreAchievement() {
        let globalScore = UserDefaults.standard.integer(forKey: "GlobalScore")
        if globalScore >= 1000 {
            showMessage("Achievement Unlocked: 1000 Points Achieved!")
        } else {
            showMessage("Achievement Not Unlocked: Less than 1000 Points.")
        }
    }

    @objc private func checkLevelsAchievement() {
        let completedLevels = UserDefaults.standard.array(forKey: "completedLevels") as? [Bool] ?? []
        let completedCount = completedLevels.filter { $0 == true }.count
        if completedCount >= 6 {
            showMessage("Achievement Unlocked: 6 Levels Completed!")
        } else {
            showMessage("Achievement Not Unlocked: Complete at least 6 levels.")
        }
    }

    @objc private func checkGoalsAchievement() {
        let globalScore = UserDefaults.standard.integer(forKey: "GlobalScore")
        if globalScore/10 >= 20 {
            showMessage("Achievement Unlocked: 20 Goals Scored!")
        } else {
            showMessage("Achievement Not Unlocked: Less than 20 Goals Scored.")
        }
    }

    private func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Achievement Status", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupBackgroundImageForGlobalScore() {
        view.addSubview(backgroundImageForGlobalScore)
        backgroundImageForGlobalScore.layer.zPosition = 10

        backgroundImageForGlobalScore.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(40)
            make.width.equalTo(175)
        }
        
        backgroundImageForGlobalScore.addSubview(globalScoreDisplayLabel)
        globalScoreDisplayLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupMainGameLevelsViewControllerLayout() {
        view.addSubview(fullScreenBackgroundImageViewForAllGameControllers)

        fullScreenBackgroundImageViewForAllGameControllers.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupCloseButton() {
        view.addSubview(closeButtonForExitingLevelSelectionView)
        closeButtonForExitingLevelSelectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(55)
        }
    }

    @objc private func closeLevelSelectionView() {
        self.dismiss(animated: true, completion: nil)
    }
}
