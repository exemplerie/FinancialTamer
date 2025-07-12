import UIKit
import SwiftUI

class AnalysisViewController: UIViewController {
    private var direction : Direction = .outcome
    private var tableView = UITableView()
    @State private var analysisViewModel: TransactionsHistoryViewModel = TransactionsHistoryViewModel(direction: .outcome)
    private var filterView: FilterHeaderView = FilterHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterView()
        setupTableView()
        setupNavigationBar()
        setupBindings()
    }
    
    func setupFilterView() {
        filterView.configure(
            startDate: analysisViewModel.startDate,
            endDate: analysisViewModel.endDate,
            selectedSort: analysisViewModel.selectedSort,
            totalAmount: analysisViewModel.totalAmount
        )
        filterView.onStartDateChanged = { [weak self] date in
            self?.analysisViewModel.startDate = date
        }
        filterView.onEndDateChanged = { [weak self] date in
            self?.analysisViewModel.endDate = date
        }
        filterView.onSortOptionSelected = { [weak self] option in
            self?.analysisViewModel.selectedSort = option
        }
        view.addSubview(filterView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupTableView() {
        
        view.backgroundColor = .systemGroupedBackground
        
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        
        tableView.register(AnalysisTransactionCell.self, forCellReuseIdentifier: "AnalysisTransactionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 65
        
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Операции"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .lightGray
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10)
        ])
        
    }
    private func setupNavigationBar() {
        navigationItem.title = "Анализ"
        navigationItem.largeTitleDisplayMode = .always
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .element
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupBindings() {
        analysisViewModel.onTransactionsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.filterView.configure(
                    startDate: self?.analysisViewModel.startDate ?? Date(),
                    endDate: self?.analysisViewModel.endDate ?? Date(),
                    selectedSort: self?.analysisViewModel.selectedSort ?? .byDate,
                    totalAmount: self?.analysisViewModel.totalAmount ?? 0
                )
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension AnalysisViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return max(analysisViewModel.visibleTransactions.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if analysisViewModel.visibleTransactions.isEmpty {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "За данный период транзакций нет"
                cell.textLabel?.textAlignment = .center
                cell.backgroundColor = .white
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnalysisTransactionCell", for: indexPath) as! AnalysisTransactionCell
                cell.configure(with: analysisViewModel.visibleTransactions[indexPath.row], totalAmount: analysisViewModel.totalAmount)
                
                if indexPath.row == 0 {
                    cell.layer.cornerRadius = 12
                    cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    cell.clipsToBounds = true
                }
                
                if indexPath.row == analysisViewModel.visibleTransactions.count - 1 {
                    cell.layer.cornerRadius = 12
                    cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                    cell.clipsToBounds = true
                }
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

class AnalysisTransactionCell: UITableViewCell {
    private let totalAmount: Int = 0
    private let emojiLabel = UILabel()
    private let categoryLabel = UILabel()
    private let commentLabel = UILabel()
    private let amountLabel = UILabel()
    private let currencyLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let percentageLabel = UILabel()
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16.5
        view.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        return stack
    }()
    
    private let amountVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .trailing
        return stack
    }()
    
    private let amountHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        emojiLabel.font = .preferredFont(forTextStyle: .title2)
        emojiLabel.textAlignment = .center
        
        bubbleView.addSubview(emojiLabel)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bubbleView.widthAnchor.constraint(equalToConstant: 33),
            bubbleView.heightAnchor.constraint(equalToConstant: 33),
            emojiLabel.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor)
        ])
        
        categoryLabel.font = .preferredFont(forTextStyle: .body)
        
        commentLabel.font = .preferredFont(forTextStyle: .caption2)
        commentLabel.textColor = .gray
        
        amountLabel.font = .preferredFont(forTextStyle: .body)
        
        currencyLabel.font = .preferredFont(forTextStyle: .body)
        
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .gray
        chevronImageView.contentMode = .scaleAspectFit
        
        amountVerticalStackView.addArrangedSubview(percentageLabel)
        amountVerticalStackView.addArrangedSubview(amountLabel)
        
        amountHorizontalStackView.addArrangedSubview(amountVerticalStackView)
        amountHorizontalStackView.addArrangedSubview(chevronImageView)
        
        textStackView.addArrangedSubview(categoryLabel)
        textStackView.addArrangedSubview(commentLabel)
        
        stackView.addArrangedSubview(bubbleView)
        stackView.addArrangedSubview(textStackView)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(amountHorizontalStackView)
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func configure(with transaction: Transaction, totalAmount: Decimal) {
        emojiLabel.text = transaction.category.emoji.description
        
        categoryLabel.text = transaction.category.name
        commentLabel.text = transaction.comment
        commentLabel.isHidden = transaction.comment == nil
        
        amountLabel.text = "\(transaction.amount.description) \(transaction.account.currency)"
        currencyLabel.text = transaction.account.currency
        
        if totalAmount > 0 {
            let percentage = (transaction.amount as NSDecimalNumber)
                .dividing(by: totalAmount as NSDecimalNumber)
                .multiplying(by: 100)
            
            let percentageFormatter = NumberFormatter()
            percentageFormatter.numberStyle = .decimal
            percentageFormatter.maximumFractionDigits = 1
            
            percentageLabel.text = "\(percentageFormatter.string(from: percentage) ?? "0")% "
        } else {
            percentageLabel.text = "0%"
        }
    }
}

class FilterHeaderView: UIView {
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let sortButton = UIButton(type: .system)
    private let totalAmountLabel = UILabel()
    private let stackView = UIStackView()
    
    var onStartDateChanged: ((Date) -> Void)?
    var onEndDateChanged: ((Date) -> Void)?
    var onSortOptionSelected: ((SortOption) -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    private func setupViews() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        let startDateStack = createDateStack(title: "Период: начало", datePicker: startDatePicker)
        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        
        let endDateStack = createDateStack(title: "Период: конец", datePicker: endDatePicker)
        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        
        sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        sortButton.contentHorizontalAlignment = .center
        
        let sumStack = createSumStack()
        
        stackView.addArrangedSubview(startDateStack)
        stackView.addArrangedSubview(endDateStack)
        stackView.addArrangedSubview(sortButton)
        stackView.addArrangedSubview(sumStack)
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    private func createDateStack(title: String, datePicker: UIDatePicker) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        datePicker.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let stack = UIStackView(arrangedSubviews: [label, datePicker])
        stack.axis = .horizontal
        return stack
    }
    
    private func createSumStack() -> UIStackView {
        let label = UILabel()
        label.text = "Сумма"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        totalAmountLabel.textAlignment = .right
        
        let stack = UIStackView(arrangedSubviews: [label, totalAmountLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }
    
    func configure(startDate: Date, endDate: Date, selectedSort: SortOption, totalAmount: Decimal) {
        startDatePicker.date = startDate
        endDatePicker.date = endDate
        sortButton.setTitle("Сортировка: \(selectedSort.rawValue)", for: .normal)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        totalAmountLabel.text = "\(formatter.string(from: totalAmount as NSDecimalNumber) ?? "0") ₽"
    }
    
    @objc private func startDateChanged() {
        onStartDateChanged?(startDatePicker.date)
    }
    
    @objc private func endDateChanged() {
        onEndDateChanged?(endDatePicker.date)
    }
    
    @objc private func sortButtonTapped() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        SortOption.allCases.forEach { option in
            alert.addAction(UIAlertAction(title: option.rawValue, style: .default) { _ in
                self.onSortOptionSelected?(option)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = sortButton
            popover.sourceRect = sortButton.bounds
        }
        
        window?.rootViewController?.present(alert, animated: true)
    }
    
}
