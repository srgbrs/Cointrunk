import UIKit

final class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    weak var coordinator: AppCoordinator?
    private var viewModel: MainViewModel!
    
    private var mainView: MainView! {
        return view as? MainView
    }

    // MARK: - Lifecycle
    override func loadView() {
        let mainView = MainView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let walletBalanceService = WalletBalanceService(context: context)
        
        viewModel = MainViewModel(balanceService: walletBalanceService)
        setupBindings()
        
        viewModel.fetchLatestBitcoinRate()
        viewModel.loadTransactions()
        viewModel.fetchAndUpdateBalanceDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadTransactions()
        viewModel.fetchAndUpdateBalanceDisplay()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        mainView.configureAddTransactionButton(target: self, action: #selector(addTransactionButtonTapped))
        mainView.configureRefreshBalanceButton(target: self, action: #selector(showBalanceUpdateAlert))
        
        viewModel.onRateUpdate = { [weak self] rate in
            DispatchQueue.main.async {
                self?.mainView.updateBitcoinRateLabel(with: rate)
            }
        }

        mainView.transactionsTableView.dataSource = self
        mainView.transactionsTableView.delegate = self
        
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.mainView.transactionsTableView.reloadData()
            }
        }
        
        viewModel.onBalanceUpdated = { [weak self] newBalance in
            DispatchQueue.main.async {
                self?.mainView.updateBalanceLabel(with: newBalance)
            }
        }

        viewModel.onTransactionsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.mainView.transactionsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func showBalanceUpdateAlert() {
        let alert = UIAlertController(title: "Пополнение баланса", message: "Введите количество bitcoins", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Количество bitcoins"
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak alert] _ in
            guard let textField = alert?.textFields?.first, let text = textField.text, let amount = Decimal(string: text) else {
                return
            }
            self.viewModel.updateBalance(amount: amount)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func addTransactionButtonTapped() {
        coordinator?.showAddTransactionScreen()
    }

    // MARK: - UITableViewDataSource & UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        let transaction = viewModel.transactionForIndexPath(indexPath)
        cell.configure(with: transaction)
        return cell
    }
}
