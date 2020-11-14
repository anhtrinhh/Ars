import React, { createRef } from "react"
import { Icon } from "semantic-ui-react";
import { connect } from "react-redux";
import {UploadCustomerAvatar} from "../../actions"

class LeftPanel extends React.Component {
    constructor(props) {
        super(props);
        this.customerAvatarInput = createRef();
    }
    handleChooseAvatar = evt => {
        if (this.customerAvatarInput.current) {
            this.customerAvatarInput.current.click();
        }
    }
    handleChangeAvatar = evt => {
        var input = evt.target;
        var reader = new FileReader();
        reader.onload = function () {
            var dataURL = reader.result;
            var output = document.getElementById("cus-ava");
            output.src = dataURL;
        };
        reader.readAsDataURL(input.files[0]);
        let formData = new FormData();
        formData.append("pictureFile", input.files[0]);
        this.props.uploadFile(formData);
    }
    render() {
        let { customer } = this.props;
        return (
            <div className="left-panel">
                <div className="card-board">
                    <div className="customer-avatar">
                        <img src={customer.customerAvatar} alt="avatar" id="cus-ava" />
                        <input accept="image/x-png,image/gif,image/jpeg"
                            style={{ display: "none" }}
                            type="file"
                            ref={this.customerAvatarInput}
                            onChange={this.handleChangeAvatar}
                        />
                        <span onClick={this.handleChooseAvatar}>
                            <Icon name="edit" />
                        </span>
                    </div>
                    <p className="customer-name">Hello, {(customer.customerFirstName + ' ' + customer.customerLastName).toUpperCase()}</p>
                    <div className="info">
                        <p>Loyalty Number:</p>
                        <p>{customer.customerNo}</p>
                    </div>
                </div>
            </div>
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
        uploadFile(formData) {
            dispatch(UploadCustomerAvatar(formData))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(LeftPanel);