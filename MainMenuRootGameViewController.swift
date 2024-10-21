import UIKit
import SnapKit

class MainMenuRootGameViewController: UIViewController {
    
    var backMenuControllerClosure: (() -> ())?

    private let backGroundImageViewForAllControllers: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "BackGroundForAllControllers")
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()
    
    private let mainMenuBallImageView: UIImageView = {
        let ballImageView = UIImageView()
        ballImageView.image = UIImage(named: "MainMenuBall")
        ballImageView.contentMode = .scaleAspectFill
        return ballImageView
    }()
    
    private let mainMenuLabelImageView: UIImageView = {
        let labelImageView = UIImageView()
        labelImageView.image = UIImage(named: "MainMenuLabelImage")
        return labelImageView
    }()
    
    private let playButtonWithImage: UIButton = {
        let playButton = UIButton()
        playButton.setImage(UIImage(named: "MainPlayButtonImage"), for: .normal)
        return playButton
    }()
    
    private let storeButtonWithImage: UIButton = {
        let storeButton = UIButton()
        storeButton.setImage(UIImage(named: "StoreButtonImage"), for: .normal)
        return storeButton
    }()
    
    private let achievementsButtonWithImage: UIButton = {
        let achievementsButton = UIButton()
        achievementsButton.setImage(UIImage(named: "AchivementButtonImage"), for: .normal)
        return achievementsButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllViewsInMainMenuRootGameViewController()
        setupPlayButtonAction()
        setupStoreButtonAction()
        setupAchievementsButtonAction()
    }

    private func setupAllViewsInMainMenuRootGameViewController() {
        view.addSubview(backGroundImageViewForAllControllers)
        view.addSubview(mainMenuBallImageView)
        view.addSubview(mainMenuLabelImageView)
        view.addSubview(playButtonWithImage)
        view.addSubview(storeButtonWithImage)
        view.addSubview(achievementsButtonWithImage)

        backGroundImageViewForAllControllers.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainMenuBallImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.width.height.equalTo(250)
        }

        mainMenuLabelImageView.snp.makeConstraints { make in
            make.centerX.equalTo(mainMenuBallImageView)
            make.centerY.equalTo(mainMenuBallImageView)
            make.width.equalTo(300)
            make.height.equalTo(175)
        }

        playButtonWithImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainMenuBallImageView.snp.bottom).offset(40)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }

        storeButtonWithImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(playButtonWithImage.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }

        achievementsButtonWithImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(storeButtonWithImage.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    
    private func setupPlayButtonAction() {
        playButtonWithImage.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: playButtonWithImage)
    }

    private func setupStoreButtonAction() {
        storeButtonWithImage.addTarget(self, action: #selector(didTapStoreButton), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: storeButtonWithImage)
    }

    private func setupAchievementsButtonAction() {
        achievementsButtonWithImage.addTarget(self, action: #selector(didTapAchievementsButton), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: achievementsButtonWithImage)
    }

    @objc private func didTapPlayButton() {
        let mainGameLevelsViewController = MainGameLevelsViewController()
        mainGameLevelsViewController.backMenuControllerClosure = { [weak self] in
            self?.dismiss(animated: false)
        }
        mainGameLevelsViewController.modalTransitionStyle = .crossDissolve
        mainGameLevelsViewController.modalPresentationStyle = .fullScreen
        present(mainGameLevelsViewController, animated: true, completion: nil)
    }
    
    @objc private func didTapStoreButton() {
        let storeGameViewController = StoreGameViewController()
        storeGameViewController.modalTransitionStyle = .crossDissolve
        storeGameViewController.modalPresentationStyle = .fullScreen
        present(storeGameViewController, animated: true, completion: nil)
    }
    
    @objc private func didTapAchievementsButton() {
        let achievementsGameViewController = AchievementsGameViewController()
        achievementsGameViewController.modalTransitionStyle = .crossDissolve
        achievementsGameViewController.modalPresentationStyle = .fullScreen
        present(achievementsGameViewController, animated: true, completion: nil)
    }
}
