import React from "react";
import {Table, Button} from "semantic-ui-react";

class EmployeeTable extends React.Component {
    render() {
        return (
            <Table celled>
                <Table.Header>
                    <Table.Row>
                        <Table.HeaderCell width="1">No</Table.HeaderCell>
                        <Table.HeaderCell width="2">First name</Table.HeaderCell>
                        <Table.HeaderCell width="2">Last name</Table.HeaderCell>
                        <Table.HeaderCell width="3">Email</Table.HeaderCell>
                        <Table.HeaderCell width="2">Phone number</Table.HeaderCell>
                        <Table.HeaderCell width="1">Gender</Table.HeaderCell>
                        <Table.HeaderCell width="2">Date of birth</Table.HeaderCell>
                        <Table.HeaderCell width="3"></Table.HeaderCell>
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    <Table.Row>
                        <Table.Cell>1</Table.Cell>
                        <Table.Cell>1</Table.Cell>
                        <Table.Cell>1</Table.Cell>
                        <Table.Cell>1</Table.Cell>
                        <Table.Cell>1</Table.Cell>
                        <Table.Cell>1</Table.Cell>
                        <Table.Cell>1</Table.Cell>
                        <Table.Cell>
                            <Button color="yellow" size="small">Edit</Button>
                            <Button color="red" size="small">Delete</Button>
                        </Table.Cell>
                    </Table.Row>
                </Table.Body>
            </Table>
        )
    }
}

export default EmployeeTable;