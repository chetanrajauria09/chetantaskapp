//
//  ViewController.swift
//  ChetanTaskApp
//
//  Created by Chetan Rajauria on 08/07/25.
//

import UIKit

class PortfolioVC: UIViewController, UITableViewDelegate {
    
    private let summaryView = SummaryView()
    private let viewModel = PortfolioViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HoldingTableViewCell.self, forCellReuseIdentifier: HoldingTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let shimmerStack = ShimmerStackView(shimmerCount: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadHoldings()
    }

    private func setupUI() {
        title = PortfolioStrings.myPortfolio
        view.backgroundColor = .systemBackground
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.delegate = self
        
        view.addSubview(shimmerStack)
        view.addSubview(tableView)
        view.addSubview(summaryView)

        NSLayoutConstraint.activate([
            shimmerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            shimmerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shimmerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }
    private func setupBindings() {
        viewModel.onLoadingChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.shimmerStack.isHidden = !isLoading
                self?.tableView.isHidden = isLoading
                self?.summaryView.isHidden = isLoading
            }
        }
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.summaryView.configure(
                currentValue: viewModel.currentValue,
                totalInvestment: viewModel.totalInvestment,
                totalPNL: viewModel.totalPNL,
                todaysPNL: viewModel.todaysPNL
            )
            
            self.tableView.reloadData()
        }
    }
}
extension PortfolioVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.holdings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HoldingTableViewCell.identifier, for: indexPath) as? HoldingTableViewCell else {
            return UITableViewCell()
        }
        let holding = viewModel.holdings[indexPath.row]
        cell.configure(with: holding)
        return cell
    }
}
extension PortfolioVC: SummaryViewDelegate {
    func didToggleExpand() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
