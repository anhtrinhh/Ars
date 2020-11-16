import React from "react";
import {Dropdown} from "semantic-ui-react";


class FromField extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            selected: props.selected
        }
    }
    handleChange = (evt, data) => {
        this.setState({
            selected: data.value
        })
        this.props.setData(data.value, "FROM");
    }
    render() {
        let {data} = this.props;
        let {selected} = this.state;
        return (
            <Dropdown
                placeholder='Select departure'
                fluid
                search
                selection
                icon={null}
                options={data}
                onChange={this.handleChange}
                value={selected}
            />
        )
    }
}

export default FromField;