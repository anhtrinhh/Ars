import React from "react";
import { Form, Label } from "semantic-ui-react";
import { connect } from "react-redux";
import FormatString from "../../utils/format-string";
import { UpdateCustomer } from "../../actions";


class ContactInfo extends React.Component {
    constructor(props) {
        super(props);
        let { customer } = props;
        this.state = {
            customerEmail: customer.customerEmail,
            customerPhoneNumber: customer.customerPhoneNumber,
            customerIdentification: customer.customerIdentification,
            customerAddress: customer.customerAddress,
            errPhone: null,
            errId:null,
            errAddress: null
        }
    }
    validate(phone, identification, address) {
        const phoneRegex = /^\d{8,15}$/;
        const idRegex = /^\d{8,15}$/;
        let success = true;
        if (!phoneRegex.test(phone.trim())) {
            this.setState({
                errPhone: "Phone number is incorrect!"
            })
            success = false;
        }
        if (!idRegex.test(identification.trim())) {
            this.state({
                errId: "Identification is incorrect!"
            })
            success = false;
        }
        if (address.trim() === '') {
            this.setState({
                errAddress: "Please enter your address!"
            })
            success = false;
        }
        if (address.trim().length < 3) {
            this.setState({
                errAddress: "The address is too short!"
            })
            success = false;
        }
        return success;
    }
    UNSAFE_componentWillReceiveProps(nextprops) {
        if (nextprops.customer.customerEmail !== this.props.customer.customerEmail) {
            let { customer } = nextprops;
            this.setState({
                customerEmail: customer.customerEmail,
                customerPhoneNumber: customer.customerPhoneNumber,
                customerIdentification: customer.customerIdentification,
                customerAddress: customer.customerAddress
            });
        }
    }
    handleChangeText = evt => {
        this.setState({
            [evt.target.name]: FormatString(evt.target.value)
        })
    }
    handleSubmit = evt => {
        let { customerPhoneNumber, customerIdentification, customerAddress } = this.state;
        let validate = this.validate(customerPhoneNumber, customerIdentification, customerAddress);
        if(validate) {
            this.props.updateContactInfo({
                customerPhoneNumber,
                customerIdentification,
                customerAddress
            })
        } 
    }
    render() {
        let { customerEmail, customerPhoneNumber, customerIdentification, customerAddress,
        errPhone, errAddress, errId } = this.state;
        return (
            <Form>
                <Form.Group widths={2}>
                    <Form.Field>
                        <label>Email: </label>
                        <input type="text"
                            placeholder="Email"
                            readOnly
                            value={customerEmail}
                        />
                    </Form.Field>
                    <Form.Field>
                        <label>Phone number:</label>
                        <input type="text"
                            placeholder="Phone number"
                            value={customerPhoneNumber}
                            name="customerPhoneNumber"
                            onChange={this.handleChangeText}
                        />
                        {errPhone
                            ? (<Label pointing prompt>{errPhone}</Label>)
                            : ''}
                    </Form.Field>
                </Form.Group>
                <Form.Group widths={2}>
                    <Form.Field>
                        <label>Identification: </label>
                        <input type="text"
                            placeholder="Identification"
                            value={customerIdentification}
                            name="customerIdentification"
                            onChange={this.handleChangeText}
                        />
                        {errId
                            ? (<Label pointing prompt>{errId}</Label>)
                            : ''}
                    </Form.Field>
                    <Form.Field>
                        <label>Address:</label>
                        <input type="text"
                            placeholder="Address"
                            value={customerAddress}
                            name="customerAddress"
                            onChange={this.handleChangeText}
                        />
                        {errAddress
                            ? (<Label pointing prompt>{errAddress}</Label>)
                            : ''}
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
        updateContactInfo(customer) {
            dispatch(UpdateCustomer(customer, 0))
        }
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(ContactInfo);