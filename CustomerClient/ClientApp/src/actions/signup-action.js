import * as ActionType from "../constants/action-type";
//import ApiCaller from "../utils/apicaller";

export function SaveSignUpInfo(signUpInfo) {
    return {
        type: ActionType.SAVE_SIGNUP_INFO,
        signUpInfo
    }
}

export function ClearSignUpInfo() {
    return {
        type: ActionType.CLEAR_SIGNUP_INFO
    }
}

export function SetLoader(loaderState) {
    return {
        type: ActionType.SET_LOADER,
        loaderState
    }
}