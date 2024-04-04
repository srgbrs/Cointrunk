import UIKit

final class MainView: UIView {
    private let balanceLabel = UILabel()
    private let refreshBalanceButton = UIButton(type: .system)
    private let addTransactionButton = UIButton(type: .system)
    private let transactionsTableView = UITableView()
    private let bitcoinRateLabel = UILabel()
    
    private let upperView = UIView()
    private let tableViewContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAddTransactionButton(target: Any, action: Selector) {
        addTransactionButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func setupViews() {
        backgroundColor = .localGrey
        
        
        upperView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(upperView)
        
        upperView.backgroundColor = .localWhite
        
        upperView.layer.cornerRadius = 20
        upperView.clipsToBounds = true
        
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableViewContainer)
        
        tableViewContainer.layer.cornerRadius = 20
        tableViewContainer.clipsToBounds = true
        tableViewContainer.backgroundColor = .localWhite
        
        balanceLabel.text = "Баланс: -- BTC"
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(balanceLabel)
        
        refreshBalanceButton.setTitle("+", for: .normal)
        refreshBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(refreshBalanceButton)
        
        addTransactionButton.setTitle("Add Transaction", for: .normal)
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(addTransactionButton)
        
        bitcoinRateLabel.text = "Курс BTC: -- USD"
        bitcoinRateLabel.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(bitcoinRateLabel)
        
        transactionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "transactionCell")
        transactionsTableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.addSubview(transactionsTableView)
        transactionsTableView.backgroundColor = .clear
    }


    private func setupLayout() {
        NSLayoutConstraint.activate([
            upperView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            upperView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            upperView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            tableViewContainer.topAnchor.constraint(equalTo: upperView.bottomAnchor,constant: 10),
            tableViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tableViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            tableViewContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
            
            balanceLabel.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 20),
            balanceLabel.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 20),
            
            refreshBalanceButton.leadingAnchor.constraint(equalTo: balanceLabel.trailingAnchor, constant: 10),
            refreshBalanceButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor),
            
            addTransactionButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 20),
            addTransactionButton.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 20),
            addTransactionButton.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -20),
            
            bitcoinRateLabel.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor, constant: 20),
            bitcoinRateLabel.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 20),
            bitcoinRateLabel.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -20),
            bitcoinRateLabel.bottomAnchor.constraint(equalTo: upperView.bottomAnchor, constant: -20),
            
            transactionsTableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            transactionsTableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            transactionsTableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor)
        ])
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        bitcoinRateLabel.translatesAutoresizingMaskIntoConstraints = false
        transactionsTableView.translatesAutoresizingMaskIntoConstraints = false
    }

}
