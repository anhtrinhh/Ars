import React from "react";
import FlightDirectionList from "../../components/flight-direction/flight-direction-list";
import { Input } from "semantic-ui-react";
import { connect } from "react-redux";
import { getLongDateStr } from "../../utils/datetime-utils"

class Home extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            searchText: ''
        }
    }
    setCurrentFlightDirections(searchText) {
        let { flightDirection } = this.props;
        let flightDirectionState = {};
        for (let fd in flightDirection) {
            let city = flightDirection[fd].city.toLowerCase();
            let searchTextTrim = searchText.trim().toLowerCase();
            if (city.includes(searchTextTrim)) {
                flightDirectionState[fd] = { ...flightDirection[fd] }
            }
        }
        return flightDirectionState;
    }
    handleSearch = (evt, data) => {
        this.setState({
            searchText: data.value
        })
    }
    render() {
        let { searchText } = this.state;
        let flightDirection = this.setCurrentFlightDirections(searchText);
        return (
            <div className="content-wrapper">
                <div className="content-header">
                    <div className="container-fluid">
                        <div className="row mb-2">
                            <div className="col-sm-6">
                                <h3>Flight of the day</h3>
                                <h4>{getLongDateStr(new Date())}</h4>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content">
                    <div className="container-fluid">
                        <div className="row">
                            <div className="col-5">
                                <Input
                                    icon={{ name: 'search', circular: true, link: true }}
                                    placeholder='Enter desparture...'
                                    fluid
                                    className="mb-3"
                                    onChange={this.handleSearch}
                                    value={searchText}
                                />
                            </div>
                        </div>
                        <FlightDirectionList flightDirection={flightDirection} />
                    </div>
                </div>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        flightDirection: state.flightDirection
    }
}

export default connect(mapStateToProps)(Home);