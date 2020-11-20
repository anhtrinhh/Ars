import * as actionType from "../constants/action-type";

let initState = [];

let currentAccounts = (state = initState, action) => {
    switch(action.type) {
        case actionType.SET_CURRENT_EMPLOYEES:
            state = [...action.employees];
            return state;
        default:
            return state;
    }
}

export default currentAccounts;