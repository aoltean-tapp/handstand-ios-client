
import UIKit

protocol HSOnboardingServiceDelegate {
    func onCompletedService(_ success : Bool, withError error : HSError?)
}

class HSOnboardingService: NSObject {
    
    public var delegate : HSOnboardingServiceDelegate! = nil
    
    func start()  {
        //Implemented in child class
    }
}
