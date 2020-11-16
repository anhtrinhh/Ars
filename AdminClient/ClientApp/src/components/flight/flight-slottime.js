import React from "react";
import { Dropdown, Form } from "semantic-ui-react";
import { connect } from "react-redux";
import {getShortTimeStr} from "../../utils/datetime-utils";


class FlightSlottime extends React.Component {
    createOption(data) {
        if (data) {
            let options = [];
            data.forEach((val, ix) => {
                let text = `${getShortTimeStr(val.startTime)} to ${getShortTimeStr(val.endTime)}`;
                options.push({
                    key: ix,
                    text,
                    value: val.timeslotId
                });
            })
            return options;
        }
        return null;
    }
    render() {
        let { timeslot } = this.props;
        let options = this.createOption(timeslot);
        return (
            <Form>
                <Form.Group widths="equal">
                    <Form.Field>
                        <label>Flight time</label>
                        <Dropdown
                            placeholder='Select departure'
                            fluid
                            search
                            selection
                            icon={null}
                            options={options}
                        />
                    </Form.Field>
                </Form.Group>
            </Form>
        )
    }
}

const mapStateToProps = state => {
    return {
        timeslot: state.timeslot
    }
}

export default connect(mapStateToProps)(FlightSlottime);