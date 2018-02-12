import UIKit

class HSBarButtonItemsFactory: NSObject {

    public var manager:HSNavigationBarManager?
    
    public func barButtonItemForDictionary(navBarDict:[String:String], viewController:UIViewController) -> UIBarButtonItem? {
        
        let selector = NSSelectorFromString((navBarDict["key"]?.appending("WithProperties:viewController:"))!)
        let barButtonItem = self.perform(selector, with: navBarDict,with: viewController)
        
        return barButtonItem?.takeUnretainedValue() as? UIBarButtonItem
    }
    
    internal func getWidthForButton()->CGFloat {
        
//        if ScreenCons.SCREEN_HEIGHT < 600 {
//            return 40
//        }
        return 60
    }
    
    //MARK:- BarButtonItems
    internal func backButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapBackButton")), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "icHandstandBackArrow"), for: UIControlState.normal)
        button.setTitle(" "+"Back", for: .normal)
        button.setTitleColor(UIColor.handstandGreen(), for: .normal)
        button.titleLabel?.font = HSFontUtilities.avenirNextRegular(size: 17)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.backgroundColor = UIColor.clear

        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }

    internal func backButtonWithWhiteArrow(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.setTitle(" "+"Back", for: .normal)
        button.titleLabel?.font = HSFontUtilities.avenirNextRegular(size: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(viewController, action:Selector(("didTapBackButton")), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "icWhiteBackArrow"), for: UIControlState.normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.backgroundColor = UIColor.clear
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }

    internal func emptyTextBtn(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.setTitle("", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        let nextButton = UIBarButtonItem()
        nextButton.customView = button
        nextButton.isEnabled = true
        return nextButton
    }
    
    internal func hamburgerButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapHamburgerButton")), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "hamburgerIcon"), for: UIControlState.normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.backgroundColor = UIColor.clear
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    
    internal func upComingWorkoutsButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapUpcomingWorkoutsButton")), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "upcomingCal_Icon"), for: UIControlState.normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    internal func homeButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapHomeButton")), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "homeIcon"), for: UIControlState.normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    
    internal func dismissButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapDismissButton")), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "closeWhite"), for: UIControlState.normal)
        button.tintColor = UIColor.black
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    
    internal func notificationsButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapNotificationsButton")), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "icNotificationAlertIcon"), for: UIControlState.normal)
        button.tintColor = UIColor.black
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.backgroundColor = UIColor.clear
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    internal func inboxGreenButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.setImage(#imageLiteral(resourceName: "icInbox"), for: UIControlState.normal)
        button.tintColor = #colorLiteral(red: 0.3529411765, green: 0.7764705882, blue: 0.5725490196, alpha: 1)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    internal func inboxButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapInboxButton")), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "icInbox"), for: UIControlState.normal)
        button.tintColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    internal func editButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapEditButton")), for: UIControlEvents.touchUpInside)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = HSFontUtilities.avenirNextRegular(size: 17)
        button.setTitleColor(UIColor.handstandGreen(), for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    internal func cancelButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapCancelButton")), for: UIControlEvents.touchUpInside)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = HSFontUtilities.avenirNextRegular(size: 17)
        button.setTitleColor(UIColor.handstandGreen(), for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.backgroundColor = UIColor.clear
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    internal func doneButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapDoneButton")), for: UIControlEvents.touchUpInside)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = HSFontUtilities.avenirNextDemiBold(size: 17)
        button.setTitleColor(UIColor.handstandGreen(), for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    internal func nextButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapNextButton")), for: UIControlEvents.touchUpInside)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = HSFontUtilities.avenirNextDemiBold(size: 17)
        button.setTitleColor(UIColor.handstandGreen(), for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    internal func whiteDoneButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        
        let button = UIButton(frame: CGRect(x:0, y:0, width:getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapDoneButton")), for: UIControlEvents.touchUpInside)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = HSFontUtilities.avenirNextDemiBold(size: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
    
    internal func filterButton(properties:Dictionary<String,Any>, viewController:UIViewController) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x:0, y:0, width:self.getWidthForButton(), height:40))
        button.addTarget(viewController, action:Selector(("didTapFilterButton")), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "icFilterIcon"), for: UIControlState.normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.backgroundColor = UIColor.clear
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
}
