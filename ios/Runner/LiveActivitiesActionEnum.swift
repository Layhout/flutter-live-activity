//
//  LiveActivitiesActionEnum.swift
//  Runner
//
//  Created by Layhout Chea on 21/1/25.
//

/*
 isActivitiesAllowed,
   startLiveActivity,
   updateLiveActivity,
   endLiveActivity,
   endAllLiveActivity,
   getAllActivityIds;
 */

enum LiveActivitiesActionEnum: String {
    case isActivitiesAllowed = "isActivitiesAllowed"
    case startLiveActivity = "startLiveActivity"
    case updateLiveActivity = "updateLiveActivity"
    case endLiveActivity = "endLiveActivity"
    case endAllLiveActivity = "endAllLiveActivity"
    case getAllActivityIds = "getAllActivityIds"
}
