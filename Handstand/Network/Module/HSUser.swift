import UIKit
import SwiftyJSON

class HSUser: NSObject {
    private let kUserIdKey: String = "user_id"
    private let kUserAccessTokenKey: String = "access_token"
    private let kUserFirstNameKey: String = "first_name"
    private let kUserLastNameKey: String = "last_name"
    private let kUserEmailKey: String = "email"
    private let kUserMobileKey: String = "mobile"
    private let kUserLocationKey: String = "location"
    private let kUserPassportKey: String = "passport"
    private let kUserPassportStartKey: String = "passport_start"
    private let kUserZipCodeKey: String = "zip_code"
    private let kUserOrderPlacedKey: String = "orderPlaced"
    private let kUserPriceKey: String = "price"
    private let kUserPassportSpanKey: String = "passport_span"
    private let kUserTotalSessionKey: String = "total_session"
    private let kUserCreatedKey: String = "created"
    private let kUserBillingMonthEndDateKey: String = "billingMonthEndDate"
    private let kUserStripeCustomerKey: String = "stripeCustomer"
    private let kUserRemainingWorkoutsKey: String = "remainingWorkouts"
    private let kUserCCBrandKey: String = "ccBrand"
    private let kUserCCLast4Key: String = "ccLast4"
    private let kUserTypeKey: String = "type"
    private let kUserAvatarKey: String = "avatar"
    private let kUserTrainerDashboardUrlKey: String = "trainerDashboardURL"
    private let kUserSubscribedBeforeKey: String = "subscribeBefore"
    
    private let kUserNewPlanKey: String = "new_plan"
    private let kUserOnboardingKey: String = "onboarding"
    private let kUserQuizDataKey: String = "quiz_data"
    private let kUserGenderKey: String = "gender"
    private let kUserDateOfBirthKey: String = "date_of_birth"
    
    public var user_id: String?
    public var accessToken: String?
    public var firstname: String?
    public var lastname: String?
    public var email: String?
    public var mobile: String?
    public var location: String?
    public var passport: Float?
    public var passport_start: String?
    public var zip_code: String?
    public var orderPlaced: Float?
    public var price: Float?
    public var passport_span: Float?
    public var total_session: Float?
    public var created: String?
    public var billingMonthEndDate: String?
    public var stripeCustomer: String?
    public var remainingWorkouts: Float?
    public var ccBrand: String?
    public var ccLast4: String?
    public var type: String?
    public var avatar: String?
    public var trainerDashboardURL: String?
    public var subscribeBefore: Bool?
    public var newPlan: Bool = false
    public var quizData: HSQuizPostData?
    public var onboarding: Bool = false
    public var gender:Int?
    public var dateOfBirth:String?
    
    public convenience init(object: Any) {
        if(object is Dictionary<String, Any>) {
            self.init(dictionary:object as! Dictionary<String, Any>)
        }else {
            self.init(json: JSON(object))
        }
    }
    
    public init(dictionary: Dictionary<String, Any>) {
        user_id = dictionary[string:kUserIdKey]
        accessToken = dictionary[string:kUserAccessTokenKey]
        firstname = dictionary[string:kUserFirstNameKey]
        lastname = dictionary[string:kUserLastNameKey]
        email = dictionary[string:kUserEmailKey]
        mobile = dictionary[string:kUserMobileKey]
        location = dictionary[string:kUserLocationKey]
        passport = dictionary[float:kUserPassportKey]
        zip_code = dictionary[string:kUserZipCodeKey]
        orderPlaced = dictionary[float:kUserOrderPlacedKey]
        price = dictionary[float:kUserPriceKey]
        passport_span = dictionary[float:kUserPassportSpanKey]
        total_session = dictionary[float:kUserTotalSessionKey]
        created = dictionary[string:kUserCreatedKey]
        billingMonthEndDate = dictionary[string:kUserBillingMonthEndDateKey]
        stripeCustomer = dictionary[string:kUserStripeCustomerKey]
        remainingWorkouts = dictionary[float:kUserRemainingWorkoutsKey]
        ccBrand = dictionary[string:kUserCCBrandKey]
        ccLast4 = dictionary[string:kUserCCLast4Key]
        type = dictionary[string:kUserTypeKey]
        avatar = dictionary[string:kUserAvatarKey]
        trainerDashboardURL = dictionary[string:kUserTrainerDashboardUrlKey]
        subscribeBefore = dictionary[bool:kUserSubscribedBeforeKey]
        
        quizData = HSQuizPostData(object: dictionary[kUserQuizDataKey] as! Dictionary<String,Any>)
        onboarding = dictionary[bool:kUserOnboardingKey]!
        newPlan = dictionary[bool:kUserNewPlanKey]!
        gender = dictionary[int:kUserGenderKey] ?? nil
        dateOfBirth = dictionary[string:kUserDateOfBirthKey] ?? nil
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        user_id = json[kUserIdKey].string
        accessToken = json[kUserAccessTokenKey].string
        firstname = json[kUserFirstNameKey].string
        lastname = json[kUserLastNameKey].string
        email = json[kUserEmailKey].string
        mobile = json[kUserMobileKey].string
        location = json[kUserLocationKey].string
        passport = json[kUserPassportKey].float
        zip_code = json[kUserZipCodeKey].string
        orderPlaced = json[kUserOrderPlacedKey].float
        price = json[kUserPriceKey].float
        passport_span = json[kUserPassportSpanKey].float
        total_session = json[kUserTotalSessionKey].float
        created = json[kUserCreatedKey].string
        billingMonthEndDate = json[kUserBillingMonthEndDateKey].string
        stripeCustomer = json[kUserStripeCustomerKey].string
        remainingWorkouts = json[kUserRemainingWorkoutsKey].float
        ccBrand = json[kUserCCBrandKey].string
        ccLast4 = json[kUserCCLast4Key].string
        type = json[kUserTypeKey].string
        avatar = json[kUserAvatarKey].string
        trainerDashboardURL = json[kUserTrainerDashboardUrlKey].string
        subscribeBefore = json[kUserSubscribedBeforeKey].bool
        
        quizData = HSQuizPostData(json: json[kUserQuizDataKey])
        onboarding = json[kUserOnboardingKey].bool!
        newPlan = json[kUserNewPlanKey].bool!
        gender = json[kUserGenderKey].int
        dateOfBirth = json[kUserDateOfBirthKey].string
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = user_id { dictionary[kUserIdKey] = value }
        if let value = accessToken { dictionary[kUserAccessTokenKey] = value }
        if let value = firstname { dictionary[kUserFirstNameKey] = value }
        if let value = lastname { dictionary[kUserLastNameKey] = value }
        if let value = email { dictionary[kUserEmailKey] = value }
        if let value = mobile { dictionary[kUserMobileKey] = value }
        if let value = location { dictionary[kUserLocationKey] = value }
        if let value = passport {dictionary[kUserPassportKey]=value}
        if let value = zip_code {dictionary[kUserZipCodeKey]=value}
        if let value = orderPlaced {dictionary[kUserOrderPlacedKey]=value}
        if let value = price {dictionary[kUserPriceKey]=value}
        if let value = passport_span {dictionary[kUserPassportSpanKey]=value}
        if let value = total_session {dictionary[kUserTotalSessionKey]=value}
        if let value = created {dictionary[kUserCreatedKey]=value}
        if let value = billingMonthEndDate {dictionary[kUserBillingMonthEndDateKey]=value}
        if let value = stripeCustomer {dictionary[kUserStripeCustomerKey]=value}
        if let value = remainingWorkouts {dictionary[kUserRemainingWorkoutsKey]=value}
        if let value = ccBrand {dictionary[kUserCCBrandKey]=value}
        if let value = ccLast4 {dictionary[kUserCCLast4Key]=value}
        if let value = type {dictionary[kUserTypeKey]=value}
        if let value = avatar {dictionary[kUserAvatarKey]=value}
        if let value = trainerDashboardURL {dictionary[kUserTrainerDashboardUrlKey]=value}
        if let value = subscribeBefore {dictionary[kUserSubscribedBeforeKey]=value}
        if let value = quizData { dictionary[kUserQuizDataKey] = value.dictionaryRepresentation() }
        dictionary[kUserNewPlanKey] = newPlan
        dictionary[kUserOnboardingKey] = onboarding
        if let value = gender {dictionary[kUserGenderKey]=value}
        if let value = dateOfBirth {dictionary[kUserDateOfBirthKey]=value}
        
        return dictionary
    }
    
}

extension HSUser {
    func name() -> String {
        return firstname! + " " + lastname!
    }
}
