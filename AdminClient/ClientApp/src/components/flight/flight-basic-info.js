import React from "react"
import { Form } from "semantic-ui-react";
import FlightDate from "./flight-date";
import FilterFlight from "./form-filter-flight";

class BasicInfo extends React.Component {
    render() {
        return (
            <div className="row">
                <div className="col-10">
                    <Form>
                        <Form.Group widths="equal">
                            <Form.Field>
                                <label>Flight code</label>
                                <input type="text" placeholder="Flight code" />
                            </Form.Field>
                            <Form.Field>
                                <label>Flight date</label>
                                <FlightDate setDate={this.setDate} selected={null} />
                            </Form.Field>
                        </Form.Group>
                    </Form>
                </div>
                <div className="col-10">
                    <FilterFlight />
                </div>
            </div>
        )
    }
}
export default BasicInfo;