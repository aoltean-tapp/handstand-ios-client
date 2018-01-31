import UIKit

fileprivate let backButtonText  = ""
fileprivate let leftButtonsKey  = "left"
fileprivate let rightButtonsKey = "right"

enum navBarType {
    case type_None
    case type_0
    case type_1
    case type_2
    case type_3
    case type_4
    case type_5
    case type_6
    case type_7
    case type_8
    case type_9
    case type_10
    case type_11
    case type_12
    case type_13
    case type_14
}

class HSNavigationBarManager: NSObject {
    
    public var barItemsFactory:HSBarButtonItemsFactory?
    
    class var shared: HSNavigationBarManager {
        struct Static {
            static let instance: HSNavigationBarManager = HSNavigationBarManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        self.barItemsFactory = HSBarButtonItemsFactory()
        self.barItemsFactory?.manager = self
    }
    
    //MARK:- Public Functions
    public func applyProperties(key:navBarType, viewController:UIViewController, titleView:UIView? = nil) {
        
        if (titleView != nil) {
            viewController.navigationItem.titleView = titleView
        }
        
        let navBarDictionary = self.navBarDictForKey(type:key)
        if (navBarDictionary?[leftButtonsKey] != nil)  {
            
            let leftBarButtonArray = self.barButtonItemsFromDictionaryArr(dictArr: navBarDictionary?[leftButtonsKey] as! [[String : String]], forViewController: viewController)
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.setLeftBarButtonItems(leftBarButtonArray,animated: true)
        }
        
        if(navBarDictionary?[rightButtonsKey] != nil) {
            
            let rightBarButtonArray = self.barButtonItemsFromDictionaryArr(dictArr: navBarDictionary?[rightButtonsKey] as! [[String : String]], forViewController: viewController)
            viewController.navigationItem.setRightBarButtonItems(rightBarButtonArray, animated: true)
        }
        
    }
    
    fileprivate func backButtonSettingsForViewController(viewController: UIViewController) {
        
        viewController.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backArrow")
        viewController.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        
        let backItem = UIBarButtonItem(title: backButtonText, style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backItem
    }
    
    //MARK:- Private Functions - Navigation Bar methods.
    fileprivate func navBarDictForKey(type:navBarType) -> [String:Any]? {
        let navigationbarDictionary = self.navigationBarData()
        return navigationbarDictionary?[type] as? [String:Any]
    }
    
    fileprivate func navigationBarData() -> [navBarType:Any]? {
        return
            [
                .type_None:[leftButtonsKey:[["key":"emptyTextBtn"]]],
                .type_0:[leftButtonsKey:[["key":"backButton"]]],
                .type_1:[leftButtonsKey:[["key":"hamburgerButton"]],
                         rightButtonsKey:[["key":"upComingWorkoutsButton"]]],
                .type_2:[leftButtonsKey:[["key":"backButton"]],
                         rightButtonsKey:[["key":"homeButton"]]],
                .type_3:[leftButtonsKey:[["key":"backButton"]],
                         rightButtonsKey:[["key":"dismissButton"]]],
                .type_4:[leftButtonsKey:[["key":"backButtonWithWhiteArrow"]]],
                .type_5:[leftButtonsKey:[["key":"notificationsButton"]]],
                .type_6:[leftButtonsKey:[["key":"notificationsButton"]],
                         rightButtonsKey:[["key":"editButton"]]],
                .type_7:[leftButtonsKey:[["key":"cancelButton"]],
                         rightButtonsKey:[["key":"doneButton"]]],
                .type_8:[leftButtonsKey:[["key":"backButtonWithWhiteArrow"]],
                         rightButtonsKey:[["key":"doneButton"]]],
                .type_9:[leftButtonsKey:[["key":"cancelButton"]]],
                .type_10:[leftButtonsKey:[["key":"backButton"]],
                          rightButtonsKey:[["key":"filterButton"]]],
                .type_11:[leftButtonsKey:[["key":"backButtonWithWhiteArrow"]],
                          rightButtonsKey:[["key":"whiteDoneButton"]]],
                .type_12:[leftButtonsKey:[["key":"backButton"]],
                          rightButtonsKey:[["key":"doneButton"]]],
                .type_13:[leftButtonsKey:[["key":"backButton"]],
                          rightButtonsKey:[["key":"nextButton"]]],
                .type_14:[leftButtonsKey:[["key":"backButton"]],
                          rightButtonsKey:[["key":"emptyTextBtn"]]]
        ]
    }
}

extension HSNavigationBarManager {
    //MARK:- Utitility methods.
    fileprivate func barButtonItemsFromDictionaryArr(dictArr:[[String:String]], forViewController:UIViewController) ->[UIBarButtonItem]? {
        
        if (dictArr.count == 0) {
            return nil
        }
        
        var barButtons = [UIBarButtonItem]()
        let flexibleButton =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        for dict in dictArr {
            
            if let barButtonItem = self.barItemsFactory?.barButtonItemForDictionary(navBarDict:dict, viewController: forViewController) {
                
                barButtons.append(barButtonItem)
                barButtons.append(flexibleButton)
            }
        }
        return barButtons
    }
    
}
