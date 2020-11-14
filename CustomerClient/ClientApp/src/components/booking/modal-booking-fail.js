import React from "react"
import { Modal, Button, Icon } from "semantic-ui-react";
import {connect} from "react-redux";
import {SetModal} from "../../actions"

class ModalBookingFail extends React.Component {
    handleClose = evt => {
        this.props.setModal({
            isOpenModalBookingFail: false
        });
    }
    render() {
        let {isOpenModalBookingFail} = this.props.subStore;
        return (
            <Modal open={isOpenModalBookingFail} size="mini" onClose={this.handleClose}>
                <Modal.Header>Failed ticket booking</Modal.Header>
                <Modal.Content>
                    <div className="modal-booking-content">
                        <Icon name="exclamation circle" color="red" size="huge" />
                        <p>Something went wrong, please try again</p>
                    </div>
                </Modal.Content>
                <Modal.Actions>
                    <Button color="red" onClick={this.handleClose}>Ok</Button>
                </Modal.Actions>
            </Modal>
        )
    }
}

const mapStateToProps = state => {
    return {
        subStore: state.SubStore
    }
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        setModal(modalState) {
            dispatch(SetModal(modalState));
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ModalBookingFail);