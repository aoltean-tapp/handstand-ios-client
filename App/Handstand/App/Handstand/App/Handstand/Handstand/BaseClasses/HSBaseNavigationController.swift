import UIKit

class HSBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
    }
    
    private func navigationBarSetup() {
        navigationBar.barTintColor = HSColorUtility.navigationBarTintColor()
        navigationBar.isTranslucent = false
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
        
       // navigationBar.shadowImage = UIImage()
       // navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:
            UIColor.rgb(0x2A2A2A),NSFontAttributeName:HSFontUtilities.avenirNextDemiBold(size: 17)]
        
        UITextField.appearance().tintColor = UIColor.rgb(0x5ACA96)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let transition:CATransition = CATransition.init()
        transition.duration = 0.25
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        
        self.view.layer.add(transition, forKey: kCATransition)
        super.pushViewController(viewController, animated: false)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let transition:CATransition = CATransition.init()
        transition.duration = 0.25
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        self.view.layer.add(transition, forKey: kCATransition)
        _ = super.popViewController(animated: false)
        return self.viewControllers.first
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let transition:CATransition = CATransition.init()
        transition.duration = 0.25
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        self.view.layer.add(transition, forKey: kCATransition)
        _ = super.popToRootViewController(animated: false)
        return self.viewControllers
    }
}

extension HSBaseNavigationController:UIGestureRecognizerDelegate {
    //MARK: - UIGestureRecognizerDelegate methods
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
