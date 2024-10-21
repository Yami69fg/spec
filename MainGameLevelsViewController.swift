import UIKit
import SnapKit

class MainGameLevelsViewController: UIViewController {
    
    var backMenuControllerClosure: (() -> ())?

    private let fullScreenBackgroundImageViewForAllGameControllers: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "BackGroundForAllControllers")
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()

    private let levelButtonsAndLabelsSecondaryBackgroundImageView: UIImageView = {
        let secondaryBackgroundView = UIImageView()
        secondaryBackgroundView.image = UIImage(named: "BackGroundForAllDetails")
        secondaryBackgroundView.isUserInteractionEnabled = true
        return secondaryBackgroundView
    }()

    private let levelLabelImageViewForDisplayingLevelText: UIImageView = {
        let levelLabelImage = UIImageView()
        levelLabelImage.image = UIImage(named: "LevelLabelImage")
        return levelLabelImage
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

    private var levelCompletionStatusArrayForTrackingLevelProgress: [Bool] = Array(repeating: false, count: 12)

    private let closeButtonForExitingLevelSelectionView: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "CloseButtonImage"), for: .normal)
        return button
    }()
    
    private let buttonForOpeningInstructionController: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "InstructionButtonImage"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainGameLevelsViewControllerLayout()
        loadLevelCompletionStatus()
        createAllLevelButtonsForStartingTheGame()
        setupCloseButton()
        setupBackgroundImageForGlobalScore()
    }

    private func setupMainGameLevelsViewControllerLayout() {
        view.addSubview(fullScreenBackgroundImageViewForAllGameControllers)
        view.addSubview(levelButtonsAndLabelsSecondaryBackgroundImageView)
        view.addSubview(levelLabelImageViewForDisplayingLevelText)
        view.addSubview(buttonForOpeningInstructionController)

        fullScreenBackgroundImageViewForAllGameControllers.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        levelButtonsAndLabelsSecondaryBackgroundImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalToSuperview().multipliedBy(0.375)
        }

        levelLabelImageViewForDisplayingLevelText.snp.makeConstraints { make in
            make.centerX.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView)
            make.bottom.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView.snp.top).offset(-20)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        buttonForOpeningInstructionController.snp.makeConstraints { make in
            make.centerX.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView)
            make.top.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView.snp.bottom).offset(30)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
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

    private func loadLevelCompletionStatus() {
        let completedLevels = UserDefaults.standard.array(forKey: "completedLevels") as? [Bool] ?? Array(repeating: false, count: 12)
        levelCompletionStatusArrayForTrackingLevelProgress = completedLevels
        
        if levelCompletionStatusArrayForTrackingLevelProgress.isEmpty || !levelCompletionStatusArrayForTrackingLevelProgress[0] {
            levelCompletionStatusArrayForTrackingLevelProgress[0] = true
            saveLevelCompletionStatus()
        }
    }

    private func saveLevelCompletionStatus() {
        UserDefaults.standard.set(levelCompletionStatusArrayForTrackingLevelProgress, forKey: "completedLevels")
    }

    private func createAllLevelButtonsForStartingTheGame() {
        for currentLevelIndex in 0..<12 {
            let levelButtonForSpecificLevelAtIndex = UIButton(type: .custom)
            levelButtonForSpecificLevelAtIndex.tag = currentLevelIndex + 1
            levelButtonForSpecificLevelAtIndex.layer.zPosition = 1
            levelButtonForSpecificLevelAtIndex.addTarget(self, action: #selector(openSpecificGameBasedOnButtonTapped(_:)), for: .touchUpInside)
            addButtonSoundEffectOnTouchDown(uiButton: levelButtonForSpecificLevelAtIndex)
            levelButtonsAndLabelsSecondaryBackgroundImageView.addSubview(levelButtonForSpecificLevelAtIndex)

            levelButtonForSpecificLevelAtIndex.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.175)
                make.height.equalTo(levelButtonForSpecificLevelAtIndex.snp.width)
                
                if currentLevelIndex % 4 == 0 {
                    make.left.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView.snp.left).offset(35)
                } else {
                    make.left.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView.subviews[currentLevelIndex - 1].snp.right).offset(5)
                }

                if currentLevelIndex / 4 == 0 {
                    make.top.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView.snp.top).offset(50)
                } else {
                    make.top.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView.subviews[currentLevelIndex - 4].snp.bottom).offset(15)
                }
            }

            configureAppearanceOfLevelButtonBasedOnCompletionStatus(levelButtonForSpecificLevelAtIndex, forIndex: currentLevelIndex)
        }
    }

    private func configureAppearanceOfLevelButtonBasedOnCompletionStatus(_ levelButton: UIButton, forIndex currentLevelIndex: Int) {
        let levelNumber = currentLevelIndex + 1

        if levelCompletionStatusArrayForTrackingLevelProgress[currentLevelIndex] {
            levelButton.setImage(UIImage(named: "DefaulButtonImage"), for: .normal)
            let levelNumberLabelForButtonDisplayingLevelNumber = UILabel()
            levelNumberLabelForButtonDisplayingLevelNumber.text = "\(levelNumber)"
            levelNumberLabelForButtonDisplayingLevelNumber.textColor = .white
            levelNumberLabelForButtonDisplayingLevelNumber.textAlignment = .center
            levelNumberLabelForButtonDisplayingLevelNumber.font = UIFont(name: "Questrian", size: 20)
            levelButton.isUserInteractionEnabled = true
            levelButton.addSubview(levelNumberLabelForButtonDisplayingLevelNumber)

            levelNumberLabelForButtonDisplayingLevelNumber.snp.makeConstraints { make in
                make.center.equalTo(levelButton)
            }
        } else {
            levelButton.setImage(UIImage(named: "LockedButtonImage"), for: .normal)
            levelButton.isUserInteractionEnabled = false
        }
    }

    private func setupCloseButton() {
        view.addSubview(closeButtonForExitingLevelSelectionView)
        closeButtonForExitingLevelSelectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(55)
        }
        closeButtonForExitingLevelSelectionView.addTarget(self, action: #selector(closeLevelSelectionView), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: closeButtonForExitingLevelSelectionView)
        buttonForOpeningInstructionController.addTarget(self, action: #selector(openInstructionControllerWhenButtonTapped), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: buttonForOpeningInstructionController)
    }

    @objc private func closeLevelSelectionView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func openInstructionControllerWhenButtonTapped() {
        let instructionController = GameSpecInstructionViewController()
        instructionController.modalPresentationStyle = .overCurrentContext
        self.present(instructionController, animated: false, completion: nil)
    }

    @objc private func openSpecificGameBasedOnButtonTapped(_ sender: UIButton) {
        let selectedLevelIndex = sender.tag - 1
        if levelCompletionStatusArrayForTrackingLevelProgress[selectedLevelIndex] {
            let mainViewGameInfoController = MainViewGameInfoController()
            mainViewGameInfoController.backMenuControllerClosure = { [weak self] in
                self?.dismiss(animated: false)
                self?.backMenuControllerClosure?()
            }
            mainViewGameInfoController.selectedLevelIndex = selectedLevelIndex
            mainViewGameInfoController.modalPresentationStyle = .overCurrentContext
            self.present(mainViewGameInfoController, animated: true, completion: nil)
        }
    }
}
