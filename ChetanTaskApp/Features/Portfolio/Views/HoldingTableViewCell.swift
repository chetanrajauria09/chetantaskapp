//
//  HoldingTableViewCell.swift
//  ChetanTaskApp
//
//  Created by Chetan Rajauria on 08/07/25.
//

import UIKit
import UIKit

final class HoldingTableViewCell: UITableViewCell {

    static let identifier = "HoldingTableViewCell"

    private let symbolLabel = UILabel()
    private let quantityLabel = UILabel()

    private let ltpTitleLabel = UILabel()
    private let ltpValueLabel = UILabel()

    private let pnlTitleLabel = UILabel()
    private let pnlValueLabel = UILabel()

    private let leftStack = UIStackView()
    private let rightStack = UIStackView()
    private let mainStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        symbolLabel.font = .boldSystemFont(ofSize: 16)
        quantityLabel.font = .systemFont(ofSize: 14)
        quantityLabel.textColor = .secondaryLabel

        ltpTitleLabel.font = .systemFont(ofSize: 12)
        ltpTitleLabel.textColor = .secondaryLabel
        ltpValueLabel.font = .systemFont(ofSize: 14)
        ltpValueLabel.textColor = .systemBlue
        ltpValueLabel.textAlignment = .right

        pnlTitleLabel.font = .systemFont(ofSize: 12)
        pnlTitleLabel.textColor = .secondaryLabel
        pnlValueLabel.font = .systemFont(ofSize: 14)
        pnlValueLabel.textAlignment = .right

        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.alignment = .leading
        leftStack.addArrangedSubview(symbolLabel)
        leftStack.addArrangedSubview(quantityLabel)

        let ltpRow = UIStackView(arrangedSubviews: [ltpTitleLabel, ltpValueLabel])
        ltpRow.axis = .horizontal
        ltpRow.spacing = 5
        ltpRow.distribution = .equalSpacing

        let pnlRow = UIStackView(arrangedSubviews: [pnlTitleLabel, pnlValueLabel])
        pnlRow.axis = .horizontal
        pnlRow.spacing = 5
        pnlRow.distribution = .equalSpacing

        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .fill
        rightStack.addArrangedSubview(ltpRow)
        rightStack.addArrangedSubview(pnlRow)

        mainStack.axis = .horizontal
        mainStack.spacing = 16
        mainStack.distribution = .equalSpacing
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        mainStack.addArrangedSubview(leftStack)
        mainStack.addArrangedSubview(rightStack)

        contentView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with holding: Holding) {
        symbolLabel.text = holding.symbol

        let quantityText = "\(PortfolioStrings.netQuantity): "
        let quantityValue = "\(holding.quantity)"
        let fullText = quantityText + quantityValue

        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: quantityText.count))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: quantityText.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: quantityText.count, length: quantityValue.count))
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: NSRange(location: quantityText.count, length: quantityValue.count))

        quantityLabel.attributedText = attributedString

        ltpTitleLabel.text = PortfolioStrings.ltp
        ltpValueLabel.text = String(format: "₹%.2f", holding.ltp)

        let investment = holding.avgPrice * Double(holding.quantity)
        let currentValue = holding.ltp * Double(holding.quantity)
        let pnl = currentValue - investment

        pnlTitleLabel.text = PortfolioStrings.pnl
        pnlValueLabel.text = String(format: "₹%.2f", pnl)
        pnlValueLabel.textColor = pnl >= 0 ? .systemGreen : .systemRed
    }
}
