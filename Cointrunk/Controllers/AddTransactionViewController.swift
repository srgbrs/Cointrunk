import UIKit


final class AddTransactionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var coordinator: AppCoordinator?
    var onTransactionAdded: (() -> Void)?
    
    private(set) var viewModel: AddTransactionViewModel!
    private var addTransactionView: AddTransactionView! {
        return view as? AddTransactionView
    }
    
    override func loadView() {
        view = AddTransactionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        addTransactionView.amountTextField.addTarget(self, action: #selector(amountTextFieldChanged(_:)), for: .editingChanged)

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let walletBalanceService = WalletBalanceService(context: context)
        viewModel = AddTransactionViewModel(balanceService: walletBalanceService)
    }
    
    
    @objc private func amountTextFieldChanged(_ textField: UITextField) {
        
        guard let viewModel = viewModel else {
            return
        }
        let validationResult = viewModel.validateAmount(textField.text)
        switch validationResult {
        case .success(let amount):
            print("Введенная сумма: \(amount)")
            
        case .failure(let errorMessage):
            showAlert(with: errorMessage)
        }
    }
    
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Ошибка валидации", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupBindings() {
        addTransactionView.categoryPicker.delegate = self
        addTransactionView.categoryPicker.dataSource = self
        addTransactionView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }
        
        guard let amountText = addTransactionView.amountTextField.text, let amount = Decimal(string: amountText), amount > 0 else {
            showAlert(with: "Введите корректную сумму.")
            return
        }
        let selectedCategoryIndex = addTransactionView.categoryPicker.selectedRow(inComponent: 0)
        let category = viewModel.categories[selectedCategoryIndex]

        viewModel.addTransaction(amount: amount, category: category) { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self?.coordinator?.popToAddTransactionScreen()
                } else {
                    if let errorMessage = errorMessage {
                        self?.showAlert(with: errorMessage)
                    }
                }
            }
        }
    }



    
    // MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        return viewModel.categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = viewModel else {
            return ""
        }
        return viewModel.categories[row].toString()
    }
    
}
