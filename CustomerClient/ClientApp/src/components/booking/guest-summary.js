import React from "react";
import { Grid } from "semantic-ui-react";
import { connect } from "react-redux";

class GuestSummary extends React.Component {
    render() {
        let { guestInfo, numberAdults, numberChildren } = this.props;
        return (
            <div className="form-wrapper">
                <h3>Passengers</h3>
                <Grid>
                    {guestInfo.map((val, ix) => (
                        <Grid.Row key={ix}>
                            <Grid.Column mobile={16} tablet={8} computer={8}>
                                <p><b>{ix + 1}. {val.guestFirstName} {val.guestLastName}</b></p>
                            </Grid.Column>
                            <Grid.Column mobile={16} tablet={8} computer={8}>
                                <p>{(ix < numberAdults) ? 'Adult'
                                    : (ix >= numberAdults && ix < numberAdults + numberChildren)
                                        ? 'Child' : 'Infant'}</p>
                            </Grid.Column>
                        </Grid.Row>
                    ))}
                </Grid>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        guestInfo: state.BookingInfo.flights[0].tickets,
        numberAdults: state.BookingInfo.numberAdults,
        numberChildren: state.BookingInfo.numberChildren
    }
}
export default connect(mapStateToProps, null)(GuestSummary)