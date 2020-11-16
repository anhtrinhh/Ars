import * as actionType from "../constants/action-type";

let init = {
    jwtToken: null,
    adminFirstName: null,
    adminLastName: null,
    adminEmail: null,
    adminPhoneNumber: null,
    adminGender: 0,
    adminAvatar: null,
    adminBirthday: null
}

let acc = JSON.parse(localStorage.getItem("account")) || JSON.parse(sessionStorage.getItem("account"));
let  initState = {...init};
if(acc) {
    initState = {...initState, ...acc}
}

let account = (state = initState, action) => {
    switch(action.type) {
        case actionType.SET_CURRENT_ACCOUNT:
            state = {...state, ...action.account};
            localStorage.setItem("account", JSON.stringify(state));
            return state;
        case actionType.CLEAR_CURRENT_ACCOUNT:
            state = {...init};
            localStorage.removeItem("account");
            return state;
        default:
            return state;
    }
}

export default account;