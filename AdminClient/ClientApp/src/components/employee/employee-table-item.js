import React from "react"
import { Table, Button } from "semantic-ui-react"
import { getShortDateStr } from "../../utils/datetime-utils"

class EmployeeItem extends React.Component {
    render() {
        let { account, index } = this.props;
        return (
            <Table.Row>
                <Table.Cell>{index}</Table.Cell>
                <Table.Cell>{account.adminId}</Table.Cell>
                <Table.Cell>{`${account.adminFirstName} ${account.adminLastName}`}</Table.Cell>
                <Table.Cell>{account.adminEmail}</Table.Cell>
                <Table.Cell>{account.adminPhoneNumber}</Table.Cell>
                <Table.Cell>{account.adminGender ? 'Female' : 'Male'}</Table.Cell>
                <Table.Cell>{getShortDateStr(new Date(account.adminBirthday))}</Table.Cell>
                <Table.Cell>{account.adminRights === 0 ? 'Root' : account.adminRights === 1 ? 'Admin' : 'Employee'}</Table.Cell>
                <Table.Cell>
                    <Button color="yellow" size="small">Edit</Button>
                    <Button color="red" size="small">Delete</Button>
                </Table.Cell>
            </Table.Row>
        )
    }
}

export default EmployeeItem;