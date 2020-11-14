import * as ActionType from "../constants/action-type";

let init = {
    errCardNumber: null,
    errExpireMonth: null,
    errExpireYear: null,
    errCardHolder: null,
    errSafelyCode: null
}

let ErrorBankCard = (state = init, action) => {
    switch(action.type) {
        case ActionType.SET_ERROR_BANK_CARD:
            state = {...state, ...action.err};
            return state;
        default:
            return state;
    }
}

export default ErrorBankCard;