
import UIKit

final class MainViewController: UIViewController {
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
   
    }
}