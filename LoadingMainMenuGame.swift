import UIKit
import SnapKit

class LoadingMainMenuGame: UIViewController {

    private let backGroundForAllControllers: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackGroundForAllControllers")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let mainMenuBall: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainMenuBall")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let loadingLabelImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LoadingLabelImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var ballAnimationDirection: CGFloat = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingViews()
        animateMainMenuBall()
        animateLoadingLabel()
        navigateToMainMenuAfterLoadingController()
    }

    private func setupLoadingViews() {
        view.addSubview(backGroundForAllControllers)
        view.addSubview(mainMenuBall)
        view.addSubview(loadingLabelImage)

        backGroundForAllControllers.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainMenuBall.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.height.equalTo(250)
        }

        loadingLabelImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainMenuBall.snp.bottom).offset(20)
            make.width.equalTo(350)
            make.height.equalTo(125)
        }
    }

    private func animateMainMenuBall() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.mainMenuBall.transform = CGAffineTransform(translationX: 0, y: 20 * self.ballAnimationDirection)
        }, completion: nil)
    }

    private func animateLoadingLabel() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.loadingLabelImage.alpha = 0.0
        }, completion: { finished in
            self.loadingLabelImage.alpha = 1.0
        })
    }

    private func navigateToMainMenuAfterLoadingController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let mainMenuViewController = MainMenuRootGameViewController()
            mainMenuViewController.modalTransitionStyle = .crossDissolve
            mainMenuViewController.modalPresentationStyle = .fullScreen
            self.present(mainMenuViewController, animated: false, completion: nil)
        }
    }
}
