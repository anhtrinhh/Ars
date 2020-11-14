import React from "react";
import { connect } from "react-redux";
import { Modal, Icon, Button } from "semantic-ui-react";
import {SetModal} from "../../actions"

class ModalInform extends React.Component {
    handleClose = evt => {
        this.props.setModal({
            modalInform: {
                state: false,
                inform: '',
                type: 0,
                title: ''
            }
        });
    }
    render() {
        let { modalInform } = this.props.subStore;
        return (
            <Modal open={modalInform.state} size="mini" onClose={this.handleClose}>
                <Modal.Header>{modalInform.title}</Modal.Header>
                <Modal.Content>
                    <div className="modal-inform-content">
                        {modalInform.type
                            ? <Icon name="check circle" color="green" size="huge" />
                            : <Icon name="exclamation circle" color="red" size="huge" />}
                        <p>{modalInform.inform}</p>
                    </div>
                </Modal.Content>
                <Modal.Actions>
                    <Button color={modalInform.type ? "green" : "red"} onClick={this.handleClose}>Ok</Button>
                </Modal.Actions>
            </Modal>
        )
    }
}

const mapStateToProp = state => {
    return {
        subStore: state.SubStore
    }
}
const mapDispatchToProps = dispatch => {
    return {
        setModal(modalState) {
            dispatch(SetModal(modalState));
        }
    }
}

export default connect(mapStateToProp, mapDispatchToProps)(ModalInform);