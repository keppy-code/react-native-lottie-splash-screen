/**
 * SplashScreen
 * from：http://attarchi.github.io
 * Author: Attarchi
 * GitHub: https://github.com/attarchi
 * Email: attarchi@me.com
 * Swift version by: React Native Community
 */

import Lottie
import React
import UIKit

@objc(SplashScreen)
public class SplashScreen: NSObject, RCTBridgeModule {

    // MARK: - Static Properties
    private static var forceToCloseByHideMethod = false
    private static var loadingView: UIView?
    private static var isAnimationFinished = false
    private static var window: UIWindow?
    private static var loop = false

    // MARK: - RCTBridgeModule
    public static func moduleName() -> String! {
        return "SplashScreen"
    }

    public func methodQueue() -> DispatchQueue! {
        return DispatchQueue.main
    }

    @objc public static func setupLottieSplash(
        in window: UIWindow?, lottieName: String, backgroundColor: UIColor = UIColor.white,
        forceToCloseByHideMethod: Bool = false, loop: Bool = false
    ) {
        guard let rootViewController = window?.rootViewController,
            let rootView = rootViewController.view
        else { return }

        self.window = window
        self.forceToCloseByHideMethod = forceToCloseByHideMethod
        self.isAnimationFinished = false
        self.loop = loop

        rootView.backgroundColor = backgroundColor

        let animationView = LottieAnimationView(name: lottieName)
        animationView.backgroundColor = .clear  // 투명 배경
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit  // Fill → Fit (비율 유지)
        animationView.loopMode = loop ? .loop : .playOnce  // <-- important for fullscreen
        animationView.animationSpeed = 1.0

        showLottieSplash(animationView, inRootView: rootView)
    }

    @objc public static func setupCustomLottieSplash(
        in window: UIWindow?, animationView: UIView, inRootView rootView: UIView,
        forceToCloseByHideMethod: Bool = false
    ) {
        self.window = window
        self.forceToCloseByHideMethod = forceToCloseByHideMethod
        self.isAnimationFinished = false

        showLottieSplash(animationView, inRootView: rootView)
    }

    @objc private static func showLottieSplash(_ animationView: UIView, inRootView rootView: UIView)
    {
        // 배경색을 가진 컨테이너 뷰 생성
        let backgroundView = UIView(frame: rootView.bounds)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.backgroundColor = rootView.backgroundColor
        rootView.addSubview(backgroundView)

        loadingView = backgroundView
        isAnimationFinished = false

        // Ensure splash screen appears on top of React Native screen
        // rootView.addSubview(animationView)
        backgroundView.addSubview(animationView)

        // 크기 조절: 고정 크기 또는 비율로 설정
        // let size: CGFloat = 300  // 원하는 크기 (pt)
        let screenWidth = rootView.frame.width
        let size = screenWidth * 0.4  // 화면 너비의 40%

        NSLayoutConstraint.activate([
            // 크기 제한
            animationView.widthAnchor.constraint(equalToConstant: size),
            animationView.heightAnchor.constraint(equalToConstant: size),
            // 중앙 정렬
            animationView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
        rootView.bringSubviewToFront(backgroundView)

        // Set higher z-index to ensure splash screen stays on top
        backgroundView.layer.zPosition = 1000

        // Temporarily raise the window level to ensure it stays on top
        let originalWindowLevel = window?.windowLevel
        window?.windowLevel = UIWindow.Level.alert + 1

        // Play animation and handle completion
        if let lottieView = animationView as? LottieAnimationView {
            if loop {
                // Looping animation – will never finish on its own
                lottieView.play()
            } else {
                // Non-looping animation – hide when done
                lottieView.play { finished in
                    DispatchQueue.main.async {
                        isAnimationFinished = true
                        hideSplashScreen()
                    }
                }
            }
        } else {
            // Fallback for non-Lottie views
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimationFinished = true
                hideSplashScreen()
            }
        }
    }

    @objc public static func hide() {
        // Only hide if forceToCloseByHideMethod is true
        if forceToCloseByHideMethod {
            hideSplashScreen()
        }
    }

    private static func hideSplashScreen() {
        guard let loadingView = loadingView else { return }

        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    loadingView.alpha = 0.0
                },
                completion: { _ in
                    loadingView.removeFromSuperview()
                    self.loadingView = nil

                    // Restore original window level
                    window?.windowLevel = UIWindow.Level.normal
                })
        }
    }

    @objc public static func jsLoadError(_ notification: Notification) {
        // If there was an error loading javascript, hide the splash screen so it can be shown.  Otherwise
        // the splash screen will remain forever, which is a hassle to debug.
        hideSplashScreen()
    }

    // MARK: - Bridge Method
    @objc public func hide() {

        SplashScreen.hide()
    }
}

// MARK: - Module Registration
extension SplashScreen {
    @objc public static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
