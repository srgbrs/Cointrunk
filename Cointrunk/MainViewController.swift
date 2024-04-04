
import UIKit

final class MainViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    
    private var mainView: MainView! {
        return view as? MainView
    }

    override func loadView() {
        let mainView = MainView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        mainView.configureAddTransactionButton(target: self, action: #selector(addTransactionButtonTapped))

    }

    @objc private func addTransactionButtonTapped() {
        coordinator?.showAddTransactionScreen()
    }
}
