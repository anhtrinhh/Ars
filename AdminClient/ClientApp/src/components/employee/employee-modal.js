import React from "react"
import { Modal, Form, Button, Dropdown } from "semantic-ui-react";
import DatePicker from "../util-components/date-picker";
import { connect } from "react-redux";
import { setSubStore } from "../../actions";

const genderOptions = [
    {
        key: 1,
        text: "Male",
        value: false
    },
    {
        key: 2,
        text: "Female",
        value: true
    }
];
let rights = [
    {
        key: 1,
        text: "Admin",
        value: 1
    },
    {
        key: 2,
        text: "Customer",
        value: 2
    }
];

class EmployeeModal extends React.Component {
    constructor(props) {
        super(props);
        let { currentAccount } = this.props;
        this.state = {
            adminId: currentAccount.adminId,
            adminFirstName: currentAccount.adminFirstName,
            adminLastName: currentAccount.adminLastName,
            adminEmail: currentAccount.adminEmail,
            adminPhoneNumber: currentAccount.adminPhoneNumber,
            adminGender: currentAccount.adminGender,
            adminBirthday: currentAccount.adminBirthday,
            adminRights: currentAccount.adminRights,
            adminPassword: currentAccount.adminPassword
        }
    }
    handleSave = evt => {

    }
    handleClose = evt => {
        this.props.setModal(false);
    }
    handleChangeDate = (date, evt) => {
        this.setState({
            adminBirthday: date
        })
    }
    handleChangeText = evt => {
        let target = evt.target;
        let name = target.name;
        let value = target.value;
        if (name === "adminPhoneNumber") {
            this.setState({
                [name]: value.replace(/\D+/, '')
            })
        } else {
            this.setState({
                [name]: value
            })
        }
    }
    handleChangeGender = (evt, data) => {
        this.setState({
            adminGender: data.value
        })
    }
    handleChangeRight = (evt, data) => {
        this.setState({
            adminRights: data.value
        })
    }
    render() {
        let {openModal} = this.props;
        let maxDate = new Date();
        maxDate.setFullYear(maxDate.getFullYear() - 18);
        let adminRight = this.props.account.adminRights;
        let rightOptions = adminRight === 0 ? rights : rights.slice(1);
        let { adminFirstName, adminLastName, adminEmail, adminPhoneNumber, adminGender, adminBirthday, adminRights } = this.state;
        return (
            <Modal open={openModal} size="small" style={{ overflow: "visible" }} onClose={this.handleClose}>
                <Modal.Header>
                    Add employee
                </Modal.Header>
                <Modal.Content>
                    <Form>
                        <Form.Group widths="equal">
                            <Form.Field>
                                <label>First name</label>
                                <input type="text"
                                    placeholder="First name"
                                    value={adminFirstName}
                                    name="adminFirstName"
                                    onChange={this.handleChangeText}
                                />
                            </Form.Field>
                            <Form.Field>
                                <label>Last name</label>
                                <input type="text"
                                    placeholder="Last name"
                                    value={adminLastName}
                                    name="adminLastName"
                                    onChange={this.handleChangeText}
                                />
                            </Form.Field>
                        </Form.Group>
                        <Form.Group widths="equal">
                            <Form.Field>
                                <label>Email</label>
                                <input type="text"
                                    placeholder="Email"
                                    value={adminEmail}
                                    name="adminEmail"
                                    onChange={this.handleChangeText}
                                />
                            </Form.Field>
                            <Form.Field>
                                <label>Phone number</label>
                                <input type="text"
                                    placeholder="Phone number"
                                    value={adminPhoneNumber}
                                    name="adminPhoneNumber"
                                    onChange={this.handleChangeText}
                                />
                            </Form.Field>
                        </Form.Group>
                        <Form.Group widths="equal">
                            <Form.Field>
                                <label>Gender</label>
                                <Dropdown selection
                                    options={genderOptions}
                                    value={adminGender}
                                    onChange={this.handleChangeGender}
                                />
                            </Form.Field>
                            <Form.Field>
                                <label>Birth of day</label>
                                <DatePicker placeholder="Select a date"
                                    selected={adminBirthday}
                                    onChange={this.handleChangeDate}
                                    maxDate={maxDate}
                                />
                            </Form.Field>
                        </Form.Group>
                        <Form.Group widths="equal">
                            <Form.Field>
                                <label>Rights</label>
                                <Dropdown selection options={rightOptions}
                                    value={adminRights}
                                    onChange={this.handleChangeRight}
                                />
                            </Form.Field>
                            <Form.Field>
                                <label>Password</label>
                                 <input type="password" />
                            </Form.Field>
                        </Form.Group>
                    </Form>
                </Modal.Content>
                <Modal.Actions>
                    <Button positive onClick={this.handleSave}>Save</Button>
                    <Button onClick={this.handleClose}>Cancel</Button>
                </Modal.Actions>
            </Modal>
        )
    }
}

const mapStateToProps = state => {
    return {
        account: state.account,
        currentAccount: state.currentAccount,
        openModal: state.subStore.openEmployeeModal
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setModal(isOpen) {
            dispatch(setSubStore({openEmployeeModal: isOpen}))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(EmployeeModal);