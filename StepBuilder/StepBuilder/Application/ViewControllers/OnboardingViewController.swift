//
//  OnboardingViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/9/25.
//


import Foundation
import UIKit
import SnapKit
import CoreMotion

class OnboardingViewController: UIViewController {
    
    private var buttonNextHeight: CGFloat = 55
    private var currentPageIndex = 0
    private var onboardingPages: [UIView] = []
    private var completion: (() -> ())?
    private let pedometer = CMPedometer()
    
    private lazy var buttonNext: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = self.buttonNextHeight / 2
        button.addTarget(self, action: #selector(buttonNext_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var contentContainerView = UIView()
    
    private lazy var onboardingIndicatorView: OnboardingIndicatorView = {
        let view = OnboardingIndicatorView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor(hex: 0xe4d2ba)
        
        onboardingPages = [
            OnboardingStepMonsterView(),
            OnboardingCoreMotionView()
        ]
        
        onboardingIndicatorView.numberOfPages = onboardingPages.count
        onboardingIndicatorView.currentPage = 0
        
        self.setup()
        showPage(index: 0, animated: false)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(completion: @escaping (() -> ())) {
        super.init(nibName: nil, bundle: nil)
        
        self.completion = completion
    }
    
    func setup() {
        view.addSubview(onboardingIndicatorView)
        onboardingIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        
        self.view.addSubview(self.buttonNext)
        self.buttonNext.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.height.equalTo(self.buttonNextHeight)
        }
        
        self.view.addSubview(contentContainerView)
        contentContainerView.snp.makeConstraints { make in
            make.top.equalTo(onboardingIndicatorView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(buttonNext.snp.top).offset(-30)
        }
    }
    
    private func showPage(index: Int, animated: Bool = true) {
        guard onboardingPages.indices.contains(index) else { return }

        let newPage = onboardingPages[index]
        let oldPage = contentContainerView.subviews.first

        newPage.alpha = animated ? 0 : 1
        contentContainerView.addSubview(newPage)

        newPage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        onboardingIndicatorView.currentPage = index
        buttonNext.setTitle(index == onboardingPages.count - 1 ? "Get Started" : "Next", for: .normal)

        guard animated, let oldPage else {
            oldPage?.removeFromSuperview()
            return
        }

        UIView.animate(withDuration: 0.25, animations: {
            oldPage.alpha = 0
            newPage.alpha = 1
        }, completion: { _ in
            oldPage.removeFromSuperview()
        })
    }
    
    @objc func buttonNext_TouchUpInside() {
        let nextIndex = currentPageIndex + 1
        let currentView = onboardingPages[currentPageIndex]
        let isCoreMotion = currentView is OnboardingCoreMotionView
        if onboardingPages.indices.contains(nextIndex) {
            if (isCoreMotion) {
                requestMotionPermission {
                    self.currentPageIndex = nextIndex
                    self.showPage(index: nextIndex)
                }
            } else {
                currentPageIndex = nextIndex
                showPage(index: nextIndex)
            }
        } else {
            if (isCoreMotion) {
                requestMotionPermission {
                    self.completion?()
                }
            } else {
                completion?()
            }
        }
    }
    
    private func requestMotionPermission(onCompletion: @escaping (() -> Void)) {
        guard CMPedometer.isStepCountingAvailable() else {
            onCompletion()
            return
        }

        let now = Date()
        let start = Calendar.current.date(byAdding: .minute, value: -1, to: now) ?? now

        pedometer.queryPedometerData(from: start, to: now) { result, error in
            onCompletion()
        }
    }
}
