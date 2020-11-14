import * as ActionType from "../constants/action-type";

let init = {
    CustomerFirstName: '',
    CustomerLastName: '',
    CustomerEmail: '',
    CustomerPhoneNumber: '',
    CustomerGender: false,
    CustomerBirthday: '',
    CustomerIdentification: '',
    CustomerAddress: ''
};
let initState = sessionStorage.getItem("csi") ? JSON.parse(sessionStorage.getItem("csi")) : {...init};

let SignUpInfo = (state = initState, action) => {
    switch (action.type) {
        case ActionType.SAVE_SIGNUP_INFO:
            state = { ...state, ...action.signUpInfo }
            sessionStorage.setItem("csi", JSON.stringify(state));
            return state;
        case ActionType.CLEAR_SIGNUP_INFO:
            sessionStorage.removeItem("csi");
            state = { ...init };
            return state;
        default:
            return state;
    }
}

export default SignUpInfo;

