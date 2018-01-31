//
//  HSNetworkConstant.swift
//  Handstand
//
//  Created by Fareeth John on 4/6/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation

// API ENDPOINTS
#if Handstand
var url = "https://api.handstandapp.com/api/v2/" //- LIVE
let base_url = "https://api.handstandapp.com/api/"
//    var url = "https://api-acceptance.handstandapp.com/api/v2/"
#elseif HandstandStage
var url = "https://api-stage.handstandapp.com/api/v2/" // - DEV
let base_url = "https://api-stage.handstandapp.com/api/"
#endif
//#elseif HandstandLiveDev
//var url = "https://api-acceptance.handstandapp.com/api/v2/" // - ACCEPTANCE
//#endif

//Card
let kPK_CardNumber = "cardNumber"
let kPK_CardExpMonth = "expMonth"
let kPK_CardExpYear = "expYear"
let kPK_CardCvv = "cvv"

//Booking
let kUserAccessToken = "access_token"
let kBK_TrainerID = "trainer_id"
let kBK_Date = "date"
let kBK_Time = "time"
let kBK_ClassType = "session_class_type"
let kBK_Location = "location"
let kBK_WorkoutSize = "workout_size"
let kBK_ZipCode = "zipcode"
let kBK_TrainerName = "trainerName"

//User
let kPU_FirstName = "firstname"
let kPU_LastName = "lastname"
let kPU_Email = "email"
let kPU_Phone = "mobile"
let kPU_Zipcode = "zip_code"
let kPU_Password = "password"
let kPU_Image = "image"

//Kahuna
let kKahunaEmail = "email"
let kKahunaUserID = "user_id"
let kKahunaUserName = "username"
let kKahunaUserType = "type"
let kKahunaUserTypeUser = "user"
let kKahunaLastSession = "last_session"
let kKahunaLastWorkout = "last_workout"
let kKahunaLogLogin = "login"
let kKahunaLogSessionBooked = "session_booked"
let kKahunaTrainer = "last_trainer"

