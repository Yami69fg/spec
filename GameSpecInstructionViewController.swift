import UIKit
import SnapKit

class GameSpecInstructionViewController: UIViewController {
    
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

    private let instructionLabelImageViewForDisplayingLevelText: UIImageView = {
        let insLabelImage = UIImageView()
        insLabelImage.image = UIImage(named: "InstructionLabelImage")
        return insLabelImage
    }()
    
    private let instructionTextLabel: UILabel = {
        let label = UILabel()
        label.text = """
        You have 5 attempts to hit the pink rectangle, which is the target, in each level.
        Depending on the level, the stages and the required number of hits (from 1 to 4) will vary.
        """
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Questrian", size: 24)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let closeButtonForExitingLevelSelectionView: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "CloseButtonImage"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainGameLevelsViewControllerLayout()
        setupInstructionTextLabel()
        setupCloseButton()
    }

    private func setupMainGameLevelsViewControllerLayout() {
        view.addSubview(fullScreenBackgroundImageViewForAllGameControllers)
        view.addSubview(levelButtonsAndLabelsSecondaryBackgroundImageView)
        view.addSubview(instructionLabelImageViewForDisplayingLevelText)

        fullScreenBackgroundImageViewForAllGameControllers.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        levelButtonsAndLabelsSecondaryBackgroundImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalToSuperview().multipliedBy(0.35)
        }

        instructionLabelImageViewForDisplayingLevelText.snp.makeConstraints { make in
            make.centerX.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView)
            make.bottom.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView.snp.top).offset(-20)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }
    
    private func setupInstructionTextLabel() {
        levelButtonsAndLabelsSecondaryBackgroundImageView.addSubview(instructionTextLabel)
        
        instructionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView.snp.top).offset(20)
            make.leading.trailing.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView).inset(15)
            make.bottom.equalTo(levelButtonsAndLabelsSecondaryBackgroundImageView.snp.bottom).offset(-20)
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
    }

    @objc private func closeLevelSelectionView() {
        self.dismiss(animated: true, completion: nil)
    }
}
