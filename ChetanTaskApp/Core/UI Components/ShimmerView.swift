//
//  ShimmerView.swift
//  ChetanTaskApp
//
//  Created by Chetan Rajauria on 08/07/25.
//

import UIKit

final class ShimmerStackView: UIStackView {

    private var shimmerViews: [ShimmerView] = []

    init(shimmerCount: Int, shimmerHeight: CGFloat = 60, spacing: CGFloat = 12) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
        createShimmers(count: shimmerCount, height: shimmerHeight)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createShimmers(count: Int, height: CGFloat) {
        for _ in 0..<count {
            let shimmer = ShimmerView()
            shimmer.translatesAutoresizingMaskIntoConstraints = false
            shimmer.heightAnchor.constraint(equalToConstant: height).isActive = true
            shimmer.layer.cornerRadius = 8
            shimmer.clipsToBounds = true
            shimmerViews.append(shimmer)
            self.addArrangedSubview(shimmer)
        }
    }

    func startShimmering() {
        shimmerViews.forEach { $0.startAnimating() }
    }

    func stopShimmering() {
        shimmerViews.forEach { $0.stopAnimating() }
    }
}

final class ShimmerView: UIView {
    
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        backgroundColor = .systemGray5

        gradientLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]

        layer.addSublayer(gradientLayer)
        startAnimating()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
    }

    func stopAnimating() {
        gradientLayer.removeAllAnimations()
    }
}
