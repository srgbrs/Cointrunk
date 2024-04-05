import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainVC = MainViewController()
        mainVC.coordinator = self
        navigationController.pushViewController(mainVC, animated: false)
    }

    func showAddTransactionScreen() {
        let addTransactionVC = AddTransactionViewController()
        addTransactionVC.coordinator = self
        
        navigationController.pushViewController(addTransactionVC, animated: true)
    }

    func popToAddTransactionScreen() {
        navigationController.popViewController(animated: true)
    }
}
