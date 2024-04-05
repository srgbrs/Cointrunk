import UIKit

class TransactionTableViewCell: UITableViewCell {
    static let identifier = "TransactionTableViewCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(timeLabel)
        addSubview(amountLabel)
        addSubview(categoryLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            amountLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            categoryLabel.leadingAnchor.constraint(equalTo: amountLabel.trailingAnchor, constant: 20),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with model: Transaction) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        timeLabel.text = formatter.string(from: model.transactionDate)
        amountLabel.text = "\(model.amount)"
        categoryLabel.text = model.category
    }
}
