import * as ActionType from "../constants/action-type";

let init = {
    cardNumber: '',
    expireMonth: null,
    expireYear: null,
    cardHolder: '',
    safelyCode: ''
}

let BankCard = (state = init, action) => {
    switch(action.type) {
        case ActionType.SET_BANK_CARD:
            state = {...state, ...action.bankCard};
            return state;
        default:
            return state;
    }
}

export default BankCard;