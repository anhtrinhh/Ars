import { Component } from "react";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

class TestPage extends Component {
    constructor(props) {
        super(props);
        this.state = {
            startDate: null,
            endDate: null
        }
    }

    render() {
        return (
            <div>
                <DatePicker monthsShown={3} selected={this.state.startDate} onChange={date => this.setState({startDate:date})} />
            </div>
        )
    }
}

export default TestPage;