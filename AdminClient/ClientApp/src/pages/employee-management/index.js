import React from "react";
import EmployeeTable from "../../components/employee-table";
import {Button, Input} from "semantic-ui-react";

class EmployeeManagement extends React.Component {
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
                                <Button>Add employee</Button>
                            </div>
                            <div className="col-4">
                                <Input type="text" fluid className="ml-2" placeholder="Search..." icon="search"/>
                            </div>
                        </div>
                        <EmployeeTable />
                    </div>
                </div>
            </div>
        )
    }
}

export default EmployeeManagement;