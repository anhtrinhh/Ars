import { Select } from "semantic-ui-react";
import { connect } from "react-redux";
import { SetNumberGuest } from "../../actions"

const option1 = [
    { key: 1, text: '1', value: 1 },
    { key: 2, text: '2', value: 2 },
    { key: 3, text: '3', value: 3 },
    { key: 4, text: '4', value: 4 },
    { key: 5, text: '5', value: 5 },
    { key: 6, text: '6', value: 6},
];
const option2 = [
    { key: 0, text: '0', value: 0 },
    { key: 1, text: '1', value: 1 },
    { key: 2, text: '2', value: 2 },
    { key: 3, text: '3', value: 3 },
    { key: 4, text: '4', value: 4 }
]
const option3 = [
    { key: 0, text: '0', value: 0 },
    { key: 1, text: '1', value: 1 },
    { key: 2, text: '2', value: 2 },
]
function SelectGuest(props) {
    const handleChangeAdults = (evt, data) => {
        props.setNumberGuest({
            numberAdults: data.value
        })
    } 
    const handleChangeChildren = (evt, data) => {
        props.setNumberGuest({
            numberChildren: data.value
        })
    }
    const handleChangeInfants = (evt, data) => {
        props.setNumberGuest({
            numberInfants: data.value
        })
    }
    let {numberAdults, numberChildren, numberInfants} = props;
    return (
        <div className="tab-search__form-row">
            <div className="tab-search__form-field--2">
                <label>Adults</label>
                <Select
                    fluid
                    options={option1}
                    placeholder="Select"
                    className="tab-search__dropdown"
                    value={numberAdults}
                    onChange={handleChangeAdults}
                />
            </div>
            <div className="tab-search__form-field--2">
                <label>Children</label>
                <Select
                    fluid
                    options={option2}
                    placeholder="Select"
                    className="tab-search__dropdown"
                    value={numberChildren}
                    onChange={handleChangeChildren}
                />
            </div>
            <div className="tab-search__form-field--2">
                <label>Infants</label>
                <Select
                    fluid
                    options={option3}
                    placeholder="Select"
                    className="tab-search__dropdown"
                    value={numberInfants}
                    onChange={handleChangeInfants}
                />
            </div>
        </div>
    )
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        setNumberGuest(numberGuest) {
            dispatch(SetNumberGuest(numberGuest))
        }
    }
}

const mapStateToProps = state => {
    return {
        numberAdults: state.BookingInfo.numberAdults,
        numberChildren: state.BookingInfo.numberChildren,
        numberInfants: state.BookingInfo.numberInfants,
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(SelectGuest);