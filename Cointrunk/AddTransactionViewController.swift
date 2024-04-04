import UIKit


final class AddTransactionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var coordinator: AppCoordinator?
    
    private let viewModel = AddTransactionViewModel()
    private var addTransactionView: AddTransactionView! {
        return view as? AddTransactionView
    }
    
    override func loadView() {
        view = AddTransactionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        addTransactionView.categoryPicker.delegate = self
        addTransactionView.categoryPicker.dataSource = self
        addTransactionView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {

        coordinator?.popToAddTransactionScreen()
    }
    
    // MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.categories.count
    }
}
