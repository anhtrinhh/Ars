import { Modal, Icon } from "semantic-ui-react";
import { connect } from "react-redux";
import { Link } from "react-router-dom";
import {setInformModal} from "../../actions";
import {useRef} from "react";

function InformModal({ informModal, setModal }) {
    let classNameHeader;
    let btnColor;
    let iconColor;
    let { icon, header, content, type, link, open, size } = informModal;
    let initRef = useRef(null);
    switch (type) {
        case 2:
            classNameHeader = "bg-danger";
            btnColor = "btn-danger";
            iconColor = "text-danger";
            break;
        default:
            classNameHeader = "bg-success";
            btnColor = "btn-success";
            iconColor = "text-success"
    }
    const handleClose = evt => {
        initRef.current.click();
        setModal({
            open: false
        });
    }
    return (
        <Modal open={open} size={size} type={type} onClose={handleClose}>
            <Modal.Header className={classNameHeader + " d-flex justify-content-between aligh-items-center text-white"}>
                <span>{header} This is header</span>
                <Icon name="remove" onClick={handleClose}/>
            </Modal.Header>
            <Modal.Content className="d-flex align-items-center">
                {
                    icon ? <Icon name={icon} size="huge" className={iconColor} /> : ''
                }
                <p className="ml-3">{content}</p>
            </Modal.Content>
            <Modal.Actions>
                {link
                    ? <Link to={link} onClick={handleClose} ref={initRef}>
                        <button className={"btn ml-4 " + btnColor}>Ok</button>
                    </Link>
                    : <button className={"btn ml-4 " + btnColor} onClick={handleClose} ref={initRef}>Ok</button>
                }
            </Modal.Actions>
        </Modal>
    )
}

const mapStateToProps = state => {
    return {
        informModal: state.informModal
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setModal(modalState) {
            dispatch(setInformModal(modalState))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(InformModal);