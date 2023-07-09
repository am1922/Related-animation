//
//  ViewController.swift
//  Related аnimation
//
//  Created by Артем Михайлов on 09.07.2023.
//

import UIKit

class ViewController: UIViewController {

    private lazy var squareView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1.0
        slider.isContinuous = true
        return slider
    }()

    private var animator: UIViewPropertyAnimator?

    private let rotationAngle: CGFloat = 90.0 * .pi / 180.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupSliderActions()
        setupAnimator()
    }

    private func setupViews() {
        view.addSubview(squareView)
        view.addSubview(slider)
    }

    private func setupConstraints() {
        squareView.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            squareView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            squareView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            squareView.heightAnchor.constraint(equalToConstant: 70),
            squareView.widthAnchor.constraint(equalToConstant: 70),

            slider.topAnchor.constraint(equalTo: squareView.bottomAnchor, constant: 40),
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }

    private func setupSliderActions() {
        slider.addTarget(self, action: #selector(moveSquareView), for: .valueChanged)
        slider.addTarget(self, action: #selector(animateView), for: .touchUpInside)
    }

    private func setupAnimator() {
        animator = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) { [weak self] in
            guard let self = self else { return }
            self.squareView.transform = CGAffineTransform(rotationAngle: self.rotationAngle).scaledBy(x: 1.5, y: 1.5)
            self.squareView.center.x += self.view.frame.width - self.squareView.bounds.width - self.view.layoutMargins.right * 3
        }
        
        animator?.pausesOnCompletion = true
        
    }

    @objc private func animateView() {
        if animator?.isRunning == true {
            slider.value = Float(animator?.fractionComplete ?? 0)
        }

        slider.setValue(slider.maximumValue, animated: true)
        animator?.startAnimation()
    }

    @objc private func moveSquareView(sender: UISlider) {
        animator?.fractionComplete = CGFloat(sender.value)
    }
}
