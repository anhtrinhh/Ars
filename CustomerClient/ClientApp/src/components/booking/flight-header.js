export default function FlightHeader({from, to}) {
    return (
        <div className="flight-header">
            <p>Choose your flight</p>
            <h3>
                <span><b>{from}</b> to <b>{to}</b></span>
            </h3>
        </div>
    )
}