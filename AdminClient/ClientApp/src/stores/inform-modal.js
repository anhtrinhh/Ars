import * as actionType from "../constants/action-type";

let initState = {
    icon: null, 
    header: '', 
    content: '', 
    type: 1, 
    link: null, 
    open: false, 
    size: "mini" 
}

let informModal = (state = initState, action) => {
    switch(action.type) {
        case actionType.SET_INFORM_MODAL:
            state = {...state, ...action.modalState};
            return state;
        default:
            return state;
    }
}

export default informModal;