import * as ActionType from "../constants/action-type";

let initState = {
    isShowLoader: false,
    showBusiness: true,
    showEconomy: true,
    showPremium: true,
    openBookingDetailModal: false,
    openFlightTimeModal: false,
    openEmployeeModal: false
}

let subStore = (state = initState, action) => {
    switch (action.type) {
        case ActionType.SET_SUB_STORE:
            state = { ...state, ...action.data }
            return { ...state };
        default:
            return state;
    }
}

export default subStore;