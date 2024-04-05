
import UIKit

final class MainViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    private var viewModel: MainViewModel!
    
    private var mainView: MainView! {
        return view as? MainView
    }

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
        
        viewModel.onBalanceUpdated = { [weak self] newBalance in
            self?.mainView.updateBalanceLabel(with: newBalance)
        }
        
        viewModel.onTransactionsUpdated = { [weak self] in
            self?.mainView.transactionsTableView.reloadData()
        }
    }
    
    @objc func showBalanceUpdateAlert() {
        let alert = UIAlertController(title: "Пополнение баланса", message: "Введите количество bitcoins", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Количество bitcoins"
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak alert] _ in
            guard let textField = alert?.textFields?.first, let text = textField.text, let amount = Decimal(string: text) else {
                return
            }
            self.updateBalance(amount: amount)
            
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func updateBalance(amount: Decimal) {
        viewModel.balanceService.updateBalance(with: amount, isAdding: true) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                   
                    print("Баланс успешно пополнен на \(amount)")
              
                     self?.fetchAndUpdateBalanceDisplay()
                } else {
               
                }
            }
        }
    }
    
    func fetchAndUpdateBalanceDisplay() {
        viewModel.balanceService.fetchCurrentBalance { [weak self] balance in
            DispatchQueue.main.async {
                if let balance = balance {
    
                    self?.mainView.updateBalanceLabel(with: balance)
                }
            }
        }
    }

    
    private func setupBindings() {
        mainView.configureAddTransactionButton(target: self, action: #selector(addTransactionButtonTapped))
            mainView.configureRefreshBalanceButton(target: self, action: #selector(showBalanceUpdateAlert))

        
        viewModel.onRateUpdate = { [weak self] rateText in
                   self?.mainView.updateBitcoinRateLabel(with: rateText)
        }

        mainView.transactionsTableView.dataSource = self
        mainView.transactionsTableView.delegate = self

        
        viewModel.onDataLoaded = { [weak self] in
             DispatchQueue.main.async {
                 self?.mainView.transactionsTableView.reloadData()
             }
         }
    }

    @objc private func addTransactionButtonTapped() {
        coordinator?.showAddTransactionScreen()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
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
