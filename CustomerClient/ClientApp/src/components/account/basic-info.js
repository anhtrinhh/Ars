import React from "react"
import { Form, Label } from "semantic-ui-react";
import DatePickerCustom from "../../components/util-components/DatePickerCustom";
import { connect } from "react-redux";
import FormatString from "../../utils/format-string";
import FormatDate from "../../utils/convertdate";
import { UpdateCustomer } from "../../actions";

const genderOptions = [
    { key: 0, text: "Male", value: false },
    { key: 1, text: "Female", value: true }
];
let maxDate = new Date();
maxDate.setFullYear(maxDate.getFullYear() - 18);
class BasicInfo extends React.Component {
    constructor(props) {
        super(props);
        let { customer } = props;
        this.state = {
            customerFirstName: customer.customerFirstName,
            customerLastName: customer.customerLastName,
            customerGender: customer.customerGender,
            customerBirthday: customer.customerBirthday,
            errFirstName: null,
            errLastName: null
        }
    }
    checkValidate(lastname, firstname) {
        let validate = true;
        if (lastname.trim().length <= 0) {
            this.setState({
                errLastName: "Please enter your lastname"
            })
            validate = false;
        }
        if (firstname.trim().length <= 0) {
            this.setState({
                errLastName: "Please enter your firstname"
            })
            validate = false;
        }
        return validate;
    }
    UNSAFE_componentWillReceiveProps(nextprops) {
        if (nextprops.customer.customerFirstName !== this.props.customer.customerFirstName) {
            let { customer } = nextprops;
            this.setState({
                customerFirstName: customer.customerFirstName,
                customerLastName: customer.customerLastName,
                customerGender: customer.customerGender,
                customerBirthday: customer.customerBirthday
            });
        }
    }
    handleChangeText = evt => {
        this.setState({
            [evt.target.name]: FormatString(evt.target.value)
        })
    }
    handleChangeDate = (date, evt) => {
        this.setState({
            customerBirthday: FormatDate(date)
        })
    }
    handleChangeSelect = (evt, data) => {
        this.setState({
            customerGender: data.value
        })
    }
    handleSubmit = evt => {
        let { customerLastName, customerFirstName, customerGender, customerBirthday } = this.state;
        let validate = this.checkValidate(customerLastName, customerFirstName);
        if(validate) {
            this.props.updateBasicInfo({
                customerFirstName,
                customerLastName,
                customerGender,
                customerBirthday
            })
        }
    }
    render() {
        let { customerLastName, customerFirstName, customerGender, customerBirthday, errFirstName, errLastName } = this.state;
        return (
            <Form>
                <Form.Group widths={2}>
                    <Form.Field>
                        <label>First Name</label>
                        <input type="text"
                            placeholder="First Name"
                            value={customerFirstName}
                            name="customerFirstName"
                            onChange={this.handleChangeText}
                        />
                        {errFirstName
                            ? (<Label pointing prompt>{errFirstName}</Label>)
                            : ''}
                    </Form.Field>
                    <Form.Field>
                        <label>Last Name</label>
                        <input type="text"
                            placeholder="Last Name"
                            value={customerLastName}
                            name="customerLastName"
                            onChange={this.handleChangeText}
                        />
                        {errLastName
                            ? (<Label pointing prompt>{errLastName}</Label>)
                            : ''}
                    </Form.Field>
                </Form.Group>
                <Form.Group widths={2}>
                    <Form.Field>
                        <label>Birth of day</label>
                        <DatePickerCustom
                            placeholderText="Choose birthday"
                            maxDate={maxDate}
                            selected={new Date(customerBirthday)}
                            onChange={this.handleChangeDate}
                        />
                    </Form.Field>
                    <Form.Field>
                        <label>Gender</label>
                        <Form.Select
                            options={genderOptions}
                            placeholder="Choose your gender"
                            value={customerGender}
                            onChange={this.handleChangeSelect}
                        />
                    </Form.Field>
                </Form.Group>
                <Form.Button size="large" color="green" onClick={this.handleSubmit}>Update</Form.Button>
            </Form>
        )
    }
}
const mapStateToProps = state => {
    return {
        customer: state.Customer
    }
}

const mapDispatchToProps = dispatch => {
    return {
        updateBasicInfo(customer) {
            dispatch(UpdateCustomer(customer, 1))
        }
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(BasicInfo);