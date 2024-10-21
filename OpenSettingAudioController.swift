import UIKit
import SnapKit

class OpenSettingAudioController: UIViewController {
    
    var backMenuController: (() -> ())?
    var backToGame: (() -> ())?
    
    private let backgroundImageViewShadow: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ShadowForBackGround")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()

    private let backgroundImageViewDetails: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "BackGroundForAllDetails")
        return imgView
    }()

    private let labelImageViewSettings: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "SettingLabelImage")
        return imgView
    }()

    private let labelForSoundSettings: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sound"
        lbl.font = UIFont(name: "Questrian", size: 32)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let buttonForSoundToggle: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let labelForVibrationSettings: UILabel = {
        let lbl = UILabel()
        lbl.text = "Vibration"
        lbl.font = UIFont(name: "Questrian", size: 32)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()

    private let buttonForVibrationToggle: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let buttonForMainMenu: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "MainMenuButtonImage"), for: .normal)
        return btn
    }()

    private let buttonForBackToGame: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "BackButtonImage"), for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        configureDefaultUserSettings()
        loadUserSettingsState()
        linkButtonActions()
    }

    private func setupUserInterface() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(backgroundImageViewShadow)
        view.addSubview(backgroundImageViewDetails)
        view.addSubview(labelImageViewSettings)
        view.addSubview(labelForSoundSettings)
        view.addSubview(buttonForSoundToggle)
        view.addSubview(labelForVibrationSettings)
        view.addSubview(buttonForVibrationToggle)
        view.addSubview(buttonForMainMenu)
        view.addSubview(buttonForBackToGame)
    }

    private func setupConstraints() {
        backgroundImageViewShadow.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backgroundImageViewDetails.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.22)
        }

        labelImageViewSettings.snp.makeConstraints { make in
            make.bottom.equalTo(backgroundImageViewDetails.snp.top).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(100)
        }

        labelForSoundSettings.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageViewDetails.snp.left).offset(50)
            make.centerY.equalToSuperview().offset(-30)
        }

        buttonForSoundToggle.snp.makeConstraints { make in
            make.left.equalTo(labelForSoundSettings.snp.right).offset(20)
            make.centerY.equalToSuperview().offset(-30)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }

        labelForVibrationSettings.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageViewDetails.snp.left).offset(30)
            make.centerY.equalToSuperview().offset(30)
        }

        buttonForVibrationToggle.snp.makeConstraints { make in
            make.left.equalTo(labelForVibrationSettings.snp.right).offset(20)
            make.centerY.equalToSuperview().offset(30)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }

        buttonForMainMenu.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageViewDetails.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }

        buttonForBackToGame.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageViewDetails.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-50)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }

    private func linkButtonActions() {
        buttonForMainMenu.addTarget(self, action: #selector(navigateToMainMenu), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: buttonForMainMenu)
        buttonForBackToGame.addTarget(self, action: #selector(navigateBackToGame), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: buttonForBackToGame)
        buttonForSoundToggle.addTarget(self, action: #selector(toggleSoundSetting), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: buttonForSoundToggle)
        buttonForVibrationToggle.addTarget(self, action: #selector(toggleVibrationSetting), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: buttonForVibrationToggle)
    }

    private func configureDefaultUserSettings() {
        if UserDefaults.standard.object(forKey: "isSoundTrue") == nil {
            UserDefaults.standard.set(true, forKey: "isSoundTrue")
        }
        if UserDefaults.standard.object(forKey: "isVibrationTrue") == nil {
            UserDefaults.standard.set(true, forKey: "isVibrationTrue")
        }
    }

    private func loadUserSettingsState() {
        let isSoundActive = UserDefaults.standard.bool(forKey: "isSoundTrue")
        let isVibrationActive = UserDefaults.standard.bool(forKey: "isVibrationTrue")

        buttonForSoundToggle.setImage(UIImage(named: isSoundActive ? "OnButtonImage" : "OffButtonImage"), for: .normal)
        buttonForVibrationToggle.setImage(UIImage(named: isVibrationActive ? "OnButtonImage" : "OffButtonImage"), for: .normal)
    }

    @objc private func toggleSoundSetting() {
        let currentSoundState = buttonForSoundToggle.currentImage == UIImage(named: "OnButtonImage")
        let newSoundState = !currentSoundState
        buttonForSoundToggle.setImage(UIImage(named: newSoundState ? "OnButtonImage" : "OffButtonImage"), for: .normal)
        UserDefaults.standard.set(newSoundState, forKey: "isSoundTrue")
    }

    @objc private func toggleVibrationSetting() {
        let currentVibrationState = buttonForVibrationToggle.currentImage == UIImage(named: "OnButtonImage")
        let newVibrationState = !currentVibrationState
        buttonForVibrationToggle.setImage(UIImage(named: newVibrationState ? "OnButtonImage" : "OffButtonImage"), for: .normal)
        UserDefaults.standard.set(newVibrationState, forKey: "isVibrationTrue")
    }

    @objc private func navigateToMainMenu() {
        dismiss(animated: false)
        backMenuController?()
    }

    @objc private func navigateBackToGame() {
        backToGame?()
        dismiss(animated: true, completion: nil)
    }
}
