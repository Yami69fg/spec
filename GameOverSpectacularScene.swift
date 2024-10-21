import UIKit
import SnapKit

class GameOverSpectacularScene: UIViewController {
    
    var backMenuController: (() -> ())?
    var restartGame: (() -> ())?
    
    var currentGameScoreValue = 0
    var endImageViewForOverGame = ""
    
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

    private let labelImageViewEnd: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "YouWinLabelImage")
        return imgView
    }()

    private let labelForCurrentScore: UILabel = {
        let lbl = UILabel()
        lbl.text = "Score: "
        lbl.font = UIFont(name: "Questrian", size: 32)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()

    private let labelForGlobalScore: UILabel = {
        let lbl = UILabel()
        lbl.text = "Total Score: \(UserDefaults.standard.integer(forKey: "GlobalScore"))"
        lbl.font = UIFont(name: "Questrian", size: 26)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()

    private let buttonForMainMenu: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "MainMenuButtonImage"), for: .normal)
        return btn
    }()

    private let buttonForResetGame: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ResetButtonImage"), for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        linkButtonActions()
    }

    private func setupUserInterface() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        if endImageViewForOverGame != "YouWinLabelImage" {
            labelImageViewEnd.image = UIImage(named: "TryNowLabelImage")
        }
        labelForCurrentScore.text = "Score: \(currentGameScoreValue)"
        
        view.addSubview(backgroundImageViewShadow)
        view.addSubview(backgroundImageViewDetails)
        view.addSubview(labelImageViewEnd)
        view.addSubview(labelForCurrentScore)
        view.addSubview(labelForGlobalScore)
        view.addSubview(buttonForMainMenu)
        view.addSubview(buttonForResetGame)
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

        labelImageViewEnd.snp.makeConstraints { make in
            make.bottom.equalTo(backgroundImageViewDetails.snp.top).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(300)
        }

        labelForCurrentScore.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageViewDetails.snp.left).offset(30)
            make.centerY.equalToSuperview().offset(-30)
        }
        
        labelForGlobalScore.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageViewDetails.snp.left).offset(30)
            make.centerY.equalToSuperview().offset(30)
        }

        buttonForMainMenu.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageViewDetails.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }

        buttonForResetGame.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageViewDetails.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-50)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }

    private func linkButtonActions() {
        buttonForMainMenu.addTarget(self, action: #selector(navigateToMainMenu), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: buttonForMainMenu)
        buttonForResetGame.addTarget(self, action: #selector(navigateForResetGame), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: buttonForResetGame)
    }

    @objc private func navigateToMainMenu() {
        dismiss(animated: false)
        backMenuController?()
    }

    @objc private func navigateForResetGame() {
        restartGame?()
        dismiss(animated: true, completion: nil)
    }
}

