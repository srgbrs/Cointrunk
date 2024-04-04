import UIKit

class AddTransactionView: UIView {
    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите сумму"
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let backgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .localGreen
        
        addSubview(backgroundView)
        backgroundView.addSubview(amountTextField)
        backgroundView.addSubview(categoryPicker)
        backgroundView.addSubview(addButton)
        
        backgroundView.backgroundColor = .localGrey
        backgroundView.layer.cornerRadius = 30
        backgroundView.clipsToBounds = true
    }
    
    func configureAddTransactionButton(target: Any, action: Selector) {
        addButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func setupLayout() {
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true

        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            
            categoryPicker.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            categoryPicker.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            categoryPicker.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            
            addButton.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
