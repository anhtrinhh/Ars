import React from "react";
import { Form } from "semantic-ui-react";
import DatePickerCustom from "../../components/util-components/DatePickerCustom";
import FormatString from "../../utils/format-string";
import {connect} from "react-redux";
import {SetGuestInfo} from "../../actions"
import FormatDate from "../../utils/convertdate";

const genderOptions = [
    { key: 0, text: "Male", value: false },
    { key: 1, text: "Female", value: true }
];
class GuestInfoForm extends React.Component {
    constructor(props) {
        super(props);
        let customer = props.bookingInfo.flights[0].tickets[props.index]
        this.state = {
            guestFirstName: customer.guestFirstName || '',
            guestLastName: customer.guestLastName || '',
            guestGender: customer.guestGender || false,
            guestBirthday: customer.guestBirthday || null
        }
    }
    handleChangeText = evt => {
        this.setState({
            [evt.target.name]: FormatString(evt.target.value)
        }, () => {
            this.props.setGuestInfo({
                [evt.target.name]: FormatString(evt.target.value.toUpperCase().trim())
            }, this.props.index)
        })
    }
    handleChangeDate = (date, evt) => {
        this.setState({
            guestBirthday: FormatDate(date)
        }, () => {
            this.props.setGuestInfo({
                guestBirthday: FormatDate(date)
            }, this.props.index)
        })
    }
    handleChangeGender = (evt, data) => {
        this.setState({
            guestGender: data.value
        }, () => {
            this.props.setGuestInfo({
                guestGender: data.value
            }, this.props.index)
        })
    }
    render() {
        const {type} = this.props;
        let label = type === 1 ? "Passenger" : type === 2 ? "Passenger (Child)" : "Passenger (Infant)";
        let {guestBirthday, guestFirstName, guestGender, guestLastName} = this.state;
        let maxd = new Date();
        let mind = null;
        if(type === 1) {
            maxd.setFullYear(maxd.getFullYear() - 12);
        } else if (type === 2) {
            maxd.setFullYear(maxd.getFullYear() - 2);
            mind = new Date();
            mind.setFullYear(mind.getFullYear() - 12);
        } else {
            mind = new Date();
            mind.setFullYear(mind.getFullYear() - 2);
        }
        return (
            <div className="form-wrapper">
                <h3>{label}</h3>
                <Form>
                    <Form.Group widths={2}>
                        <Form.Field>
                            <label>First Name</label>
                            <input type="text" 
                            placeholder="First Name" 
                            name="guestFirstName" 
                            value={guestFirstName}
                            onChange={this.handleChangeText}/>
                        </Form.Field>
                        <Form.Field>
                            <label>Last Name</label>
                            <input type="text" 
                            placeholder="Last Name" 
                            name="guestLastName" 
                            value={guestLastName}
                            onChange={this.handleChangeText}/>
                        </Form.Field>
                    </Form.Group>
                    <Form.Group widths={2}>
                        <Form.Field>
                            <label>Birth of day</label>
                            <DatePickerCustom
                                placeholderText="Choose birthday"
                                selected={guestBirthday ? new Date(guestBirthday) : null}
                                onChange={this.handleChangeDate}
                                minDate={mind}
                                maxDate={maxd}
                            />
                        </Form.Field>
                        <Form.Field>
                            <label>Gender</label>
                            <Form.Select
                                options={genderOptions}
                                placeholder="Choose your gender"
                                value={guestGender}
                                onChange={this.handleChangeGender}
                            />
                        </Form.Field>
                    </Form.Group>
                </Form>
            </div>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setGuestInfo(guestInfo, indexTicket) {
            dispatch(SetGuestInfo(guestInfo, indexTicket))
        }
    }
}

const mapStateToProps = state => {
    return {
        bookingInfo: state.BookingInfo
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(GuestInfoForm);