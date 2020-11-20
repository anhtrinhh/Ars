import React from "react";
import { Icon } from "semantic-ui-react";
import { Link } from "react-router-dom";
import {connect} from "react-redux"

class FlightDirectionItem extends React.Component {
    constructor(props) {
        super(props);
        this.linkRef = React.createRef();
    }
    handleClick = evt => {
        if (this.linkRef.current) {
            this.linkRef.current.click();
        }
    }
    render() {
        let { from, to, flightDirection, link } = this.props;
        return (
            <div className="flight-direction-item col-5" onClick={this.handleClick}>
                <div className="flight-direction-item__icon">
                    <Icon name="plane" />
                </div>
                <div className="flight-direction-item__point">
                    <div className="point">
                        <p><Icon name="map marker alternate" /> From</p>
                        <p>{flightDirection[from].city}</p>
                    </div>
                    <div className="point">
                        <p><Icon name="map marker alternate" /> To</p>
                        <p>{flightDirection[to].city}</p>
                    </div>
                </div>
                <Link to={link} ref={this.linkRef} className="d-none"></Link>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        flightDirection: state.flightDirection
    }
}

export default connect(mapStateToProps)(FlightDirectionItem);