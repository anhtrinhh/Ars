import React from "react"
import { Modal, Button, Icon } from "semantic-ui-react";
import {connect} from "react-redux";
import {SetModal} from "../../actions"

class ModalBookingSuccess extends React.Component {
    handleClose = evt => {
        this.props.setModal({
            isOpenModalBookingSuccess: false
        });
    }
    render() {
        let {isOpenModalBookingSuccess} = this.props.subStore;
        return (
            <Modal open={isOpenModalBookingSuccess} size="mini" onClose={this.handleClose}>
                <Modal.Header>Successful ticket booking</Modal.Header>
                <Modal.Content>
                    <div className="modal-booking-content">
                        <Icon name="check circle" color="green" size="huge" />
                        <p>Congratulations on your successful booking</p>
                    </div>
                </Modal.Content>
                <Modal.Actions>
                    <Button positive onClick={this.handleClose}>Ok</Button>
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
            props.history.replace("/");
            window.scrollTo(0, 0);
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ModalBookingSuccess);