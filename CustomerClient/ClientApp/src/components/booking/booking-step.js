import React from "react";
import { Grid, Icon } from "semantic-ui-react";
import "./style.scss"

class BookingStep extends React.Component {
    render() {
        let {step} = this.props;
        return (
            <Grid.Row className="booking-step">
                <Grid.Column computer="4" tablet="4" mobile="5">
                    <div className={"step-item " + (step === 1 ? "active" : "completed")}>
                        <span className="step">1</span>
                        <span className="validated">
                            <Icon name="check" />
                        </span>
                        <span className="description">
                            Flight
                        </span>
                    </div>
                </Grid.Column>
                <Grid.Column computer="4" tablet="4" mobile="5">
                    <div className={"step-item " + (step === 1 ? "disabled" : step === 2 ? "active" : "completed")}>
                        <span className="step">2</span>
                        <span className="validated">
                            <Icon name="check" />
                        </span>
                        <span className="description">
                            Passenger details
                        </span>
                    </div>
                </Grid.Column>
                <Grid.Column computer="4" tablet="4" mobile="5">
                    <div className={"step-item " + ((step === 1 || step === 2)? "disabled" : "active")}>
                        <span className="step">3</span>
                        <span className="validated">
                            <Icon name="check" />
                        </span>
                        <span className="description">
                            Payment
                        </span>
                    </div>
                </Grid.Column>
            </Grid.Row>
        )
    }
}

export default BookingStep;