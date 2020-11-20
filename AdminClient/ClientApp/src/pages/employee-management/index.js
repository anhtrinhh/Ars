import React from "react";
import EmployeeTable from "../../components/employee/employee-table";
import {Button, Input} from "semantic-ui-react";
import EmployeeModal from "../../components/employee/employee-modal";
import {connect} from "react-redux";
import { getAllAdmin, setSubStore } from "../../actions";

class EmployeeManagement extends React.Component {
    openModal = evt => {
        this.props.setModal(true)
    }
    componentDidMount() {
        this.props.getAdmins();
    }
    render() {
        return (
            <div className="content-wrapper">
                <div className="content-header">
                    <div className="container-fluid">
                        <div className="row mb-2">
                            <div className="col-12">
                                <h3>Employee Management</h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content">
                    <div className="container-fluid">
                        <div className="row">
                            <div className="col-8">
                                <Button onClick={this.openModal}>Add employee</Button>
                            </div>
                            <div className="col-4">
                                <Input type="text" fluid className="ml-2" placeholder="Search..." icon="search"/>
                            </div>
                        </div>
                        <EmployeeTable />
                        <EmployeeModal />
                    </div>
                </div>
            </div>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setModal(isOpen) {
            dispatch(setSubStore({openEmployeeModal: isOpen}))
        },
        getAdmins() {
            dispatch(getAllAdmin())
        }
    }
}

export default connect(null, mapDispatchToProps)(EmployeeManagement);