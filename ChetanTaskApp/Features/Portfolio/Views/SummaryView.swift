//
//  SummaryView.swift
//  ChetanTaskApp
//
//  Created by Chetan Rajauria on 08/07/25.
//

import UIKit

protocol SummaryViewDelegate: AnyObject {
    func didToggleExpand()
}

class SummaryView: UIView {
    weak var delegate: SummaryViewDelegate?
    private var isExpanded = false
    private let currentValueLabel = UILabel()
    private let totalInvestmentLabel = UILabel()
    private let todaysPNLLabel = UILabel()
    private let totalPNLLabel = UILabel()
    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.down")
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let pnlToggleRow = UIControl()
    private let expandableStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        pnlToggleRow.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4

        expandableStack.axis = .vertical
        expandableStack.spacing = 16
        expandableStack.translatesAutoresizingMaskIntoConstraints = false
        expandableStack.addArrangedSubview(makeRow(title: PortfolioStrings.currentValue, valueLabel: currentValueLabel))
        expandableStack.addArrangedSubview(makeRow(title: PortfolioStrings.totalInvestment, valueLabel: totalInvestmentLabel))
        expandableStack.addArrangedSubview(makeRow(title: PortfolioStrings.todaysPNL, valueLabel: todaysPNLLabel))
        expandableStack.isHidden = true

        let pnlLabel = UILabel()
        pnlLabel.text = PortfolioStrings.totalPNL
        pnlLabel.font = .systemFont(ofSize: 14)

        expandButton.setContentHuggingPriority(.required, for: .horizontal)
        pnlLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let leftStack = UIStackView(arrangedSubviews: [pnlLabel, expandButton])
        leftStack.axis = .horizontal
        leftStack.spacing = 4
        leftStack.alignment = .center

        totalPNLLabel.font = .systemFont(ofSize: 14)
        totalPNLLabel.textAlignment = .right
        totalPNLLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        totalPNLLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let rowStack = UIStackView(arrangedSubviews: [leftStack, totalPNLLabel])
        rowStack.axis = .horizontal
        rowStack.spacing = 8
        rowStack.distribution = .fill
        rowStack.alignment = .center
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        rowStack.isUserInteractionEnabled = false

        pnlToggleRow.translatesAutoresizingMaskIntoConstraints = false
        pnlToggleRow.addSubview(rowStack)

        NSLayoutConstraint.activate([
            rowStack.topAnchor.constraint(equalTo: pnlToggleRow.topAnchor, constant: 8),
            rowStack.bottomAnchor.constraint(equalTo: pnlToggleRow.bottomAnchor, constant: -8),
            rowStack.leadingAnchor.constraint(equalTo: pnlToggleRow.leadingAnchor, constant: 16),
            rowStack.trailingAnchor.constraint(equalTo: pnlToggleRow.trailingAnchor, constant: -16)
        ])

        let mainStack = UIStackView(arrangedSubviews: [expandableStack, pnlToggleRow])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }

    private func makeRow(title: String, valueLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)

        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.textAlignment = .right
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        row.axis = .horizontal
        row.distribution = .fill
        row.spacing = 8
        row.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        row.isLayoutMarginsRelativeArrangement = true
        return row
    }

    @objc private func toggleExpand() {
        isExpanded.toggle()
        expandableStack.isHidden = !isExpanded

        UIView.animate(withDuration: 0.25) {
            let angle: CGFloat = self.isExpanded ? .pi : 0
            self.expandButton.transform = CGAffineTransform(rotationAngle: angle)
            self.superview?.layoutIfNeeded()
        }
        delegate?.didToggleExpand()
    }

    func configure(currentValue: Double, totalInvestment: Double, totalPNL: Double, todaysPNL: Double) {
        currentValueLabel.text = "\(PortfolioStrings.rs)\(currentValue.formatted)"
        totalInvestmentLabel.text = "\(PortfolioStrings.rs)\(totalInvestment.formatted)"
        todaysPNLLabel.text = "\(PortfolioStrings.rs)\(todaysPNL.formatted)"
        todaysPNLLabel.textColor = todaysPNL >= 0 ? .systemGreen : .systemRed
        totalPNLLabel.text = String(format: "₹%.2f (%.2f%%)", totalPNL, (totalInvestment == 0 ? 0 : totalPNL / totalInvestment * 100))
        totalPNLLabel.textColor = totalPNL >= 0 ? .systemGreen : .systemRed
    }
}
