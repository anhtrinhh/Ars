import React from "react";
import {Table} from "semantic-ui-react";
import EmployeeItem from "./employee-table-item";
import {connect} from "react-redux"

class EmployeeTable extends React.Component {
    render() {
        let {currentAccounts} = this.props;
        return (
            <Table celled>
                <Table.Header>
                    <Table.Row>
                        <Table.HeaderCell width="1">No</Table.HeaderCell>
                        <Table.HeaderCell width="1">Employee code</Table.HeaderCell>
                        <Table.HeaderCell width="2">Name</Table.HeaderCell>
                        <Table.HeaderCell width="3">Email</Table.HeaderCell>
                        <Table.HeaderCell width="2">Phone number</Table.HeaderCell>
                        <Table.HeaderCell width="1">Gender</Table.HeaderCell>
                        <Table.HeaderCell width="2">Date of birth</Table.HeaderCell>
                        <Table.HeaderCell>Right</Table.HeaderCell>
                        <Table.HeaderCell width="3"></Table.HeaderCell>
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    {
                        currentAccounts.map((val, ix) => (
                            <EmployeeItem key={ix} index={ix+1} account={val} />
                        ))
                    }
                </Table.Body>
            </Table>
        )
    }
}

const mapStateToProps = state => {
    return {
        currentAccounts: state.currentAccounts
    }
}

export default connect(mapStateToProps)(EmployeeTable);