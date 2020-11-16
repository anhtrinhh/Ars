import React from "react";
import { Button, Form } from "semantic-ui-react"
import { getShortDateStr } from "../../utils/datetime-utils"
import FormFilter from "./form-filter-flight";
import FlightDate from "./flight-date";


class FormSearch extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            date: null,
            fromid: null,
            toid: null,
        }
    }
    setDate = (date) => {
        this.setState({
            date: date
        });
    }
    handleChangeFilter = (fromid, toid, date) => {
        this.setState({
            fromid,
            toid
        })
    }
    handleSearch = evt => {
        let { location, history } = this.props;
        let { fromid, toid, date } = this.state;
        date = getShortDateStr(date);
        history.push(`${location.pathname}/${fromid}/${toid}/${date}`, {
            from: location
        });
    }
    render() {
        let { fromid, toid, date } = this.state;
        let isDisable = true;
        if (fromid && toid && date) {
            isDisable = false;
        }
        return (
            <div className="row">
                <div className="col-10">
                    <FormFilter onChangeValue={this.handleChangeFilter} />
                </div>
                <div className="col-5">
                    <Form>
                        <Form.Group widths="equal">
                            <Form.Field>
                                <label>Flight date</label>
                                <FlightDate setDate={this.setDate} selected={date} />
                            </Form.Field>
                        </Form.Group>
                    </Form>
                </div>
                <div className="col-12">
                    <Button color="green" size="large"
                        disabled={isDisable}
                        onClick={this.handleSearch}
                    >Search</Button>
                </div>
            </div>
        )
    }
}


export default FormSearch;