import * as ActionType from "../constants/action-type";

let init = {
    startPointId: null,
    endPointId: null
}

let Cart = (state = init, action) => {
    switch(action.type) {
        case ActionType.SET_TICKET:
            return {...state}
        case ActionType.SET_CART:
            return {
                startPointId: action.startPointId,
                endPointId: action.endPointId
            }
        default:
            return state;
    }
}

export default Cart;