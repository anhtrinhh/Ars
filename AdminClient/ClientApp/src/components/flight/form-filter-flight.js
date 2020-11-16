import React from "react";
import { Form } from "semantic-ui-react";
import FromField from "./from-field";
import ToField from "./to-field";
import {connect} from "react-redux";

class FormFilter extends React.Component {
    constructor(props) {
        super(props);
        let selectedFrom = props.selectedFrom || null;
        let selectedTo = props.selectedTo || null;
        this.state = {
            from: this.createOption(props.flightDirection),
            to: this.createOption(props.flightDirection),
            fromid: null,
            toid: null,
            selectedFrom,
            selectedTo
        }
    }
    setData = (cityId, field) => {
        let { flightDirection } = this.props;
        var options = this.createOption(flightDirection[cityId].flightplan)
        let fieldState = field.toLowerCase() === "to" ? "from" : "to";
        this.setState({
            [fieldState]: options,
            [(field + "id").toLowerCase()]: cityId
        }, this.setChangeValue);
    }
    setChangeValue = () => {
        let {fromid, toid} = this.state;
        this.props.onChangeValue(fromid, toid);
    }
    createOption(fd) {
        if (fd) {
            let options = [];
            for (let key in fd) {
                options.push({
                    key,
                    text: `${fd[key].city} (${key})`,
                    value: key
                });
            }
            return options;
        }
        return null;
    }
    render() {
        let { from, to, selectedFrom, selectedTo } = this.state;
        return (
            <Form>
                <Form.Group widths="equal">
                    <Form.Field>
                        <label>From</label>
                        <FromField data={from} setData={this.setData} selected={selectedFrom} />
                    </Form.Field>
                    <Form.Field>
                        <label>To</label>
                        <ToField data={to} setData={this.setData} selected={selectedTo}/>
                    </Form.Field>
                </Form.Group>
            </Form>
        )
    }
}
const mapStateToProps = state => {
    return {
        flightDirection: state.flightDirection
    }
}


export default connect(mapStateToProps)(FormFilter);