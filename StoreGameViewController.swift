import UIKit
import SnapKit

class StoreGameViewController: UIViewController {

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
    
    private let magicCaveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "First"), for: .normal)
        return button
    }()

    private let pinCaveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Third"), for: .normal)
        return button
    }()
    
    private let darkPinkCaveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Second"), for: .normal)
        return button
    }()

    private let priceForMagicCaveBackground = 100
    private let priceForPinCaveBackground = 200
    private let priceForDarkPinkCaveBackground = 500

    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButtonForExitingLevelSelectionView.addTarget(self, action: #selector(closeLevelSelectionView), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: closeButtonForExitingLevelSelectionView)
        
        setupMainGameLevelsViewControllerLayout()
        setupCloseButton()
        setupBackgroundImageForGlobalScore()
        setupPurchaseButtons()
    }

    private func setupPurchaseButtons() {
        view.addSubview(magicCaveButton)
        magicCaveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        magicCaveButton.addTarget(self, action: #selector(purchaseMagicCaveBackground), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: magicCaveButton)

        view.addSubview(pinCaveButton)
        pinCaveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(magicCaveButton.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        pinCaveButton.addTarget(self, action: #selector(purchasePinCaveBackground), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: pinCaveButton)
        
        view.addSubview(darkPinkCaveButton)
        darkPinkCaveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pinCaveButton.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        darkPinkCaveButton.addTarget(self, action: #selector(purchaseDarkPinkCaveBackground), for: .touchUpInside)
        addButtonSoundEffectOnTouchDown(uiButton: darkPinkCaveButton)
    }

    @objc private func purchaseMagicCaveBackground() {
        handlePurchase(backgroundName: "MagicCave", cost: priceForMagicCaveBackground)
    }
    
    @objc private func purchasePinCaveBackground() {
        handlePurchase(backgroundName: "PinkCave", cost: priceForPinCaveBackground)
    }

    @objc private func purchaseDarkPinkCaveBackground() {
        handlePurchase(backgroundName: "DarkPinkCave", cost: priceForDarkPinkCaveBackground)
    }

    private func handlePurchase(backgroundName: String, cost: Int) {
        let globalScore = UserDefaults.standard.integer(forKey: "GlobalScore")
        let purchasedBackgrounds = UserDefaults.standard.array(forKey: "PurchasedBackgrounds") as? [String] ?? []
        
        if purchasedBackgrounds.contains(backgroundName) {
            setBackgroundImage(backgroundName: backgroundName)
            showMessage("\(backgroundName) background has been set!")
        } else if globalScore >= cost {
            showPurchaseConfirmationDialog(backgroundName: backgroundName, cost: cost) {
                self.completePurchase(backgroundName: backgroundName, cost: cost)
            }
        } else {
            showMessage("Not enough balance to purchase \(backgroundName) background.")
        }
    }

    private func showPurchaseConfirmationDialog(backgroundName: String, cost: Int, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Purchase Background",
                                      message: "You have enough balance to buy \(backgroundName) for \(cost) points. Do you want to purchase it?",
                                      preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }

    private func completePurchase(backgroundName: String, cost: Int) {
        var globalScore = UserDefaults.standard.integer(forKey: "GlobalScore")
        globalScore -= cost
        UserDefaults.standard.set(globalScore, forKey: "GlobalScore")

        var purchasedBackgrounds = UserDefaults.standard.array(forKey: "PurchasedBackgrounds") as? [String] ?? []
        purchasedBackgrounds.append(backgroundName)
        UserDefaults.standard.set(purchasedBackgrounds, forKey: "PurchasedBackgrounds")

        globalScoreDisplayLabel.text = String(globalScore)

        showMessage("\(backgroundName) background purchased successfully!") {
            self.setBackgroundImage(backgroundName: backgroundName)
        }
    }

    private func setBackgroundImage(backgroundName: String) {
        UserDefaults.standard.set(backgroundName, forKey: "CurrentBackground")
        showMessage("\(backgroundName) has been set as your background!")
    }

    private func showMessage(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
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
