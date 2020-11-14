import Slider from "../../components/slider"
import BookingMask from "../../components/booking-mask";
import "./style.scss"

export default function Home(props){
    return (
        <section className="content-wrapper" role="main">
            <div className="container">
                <BookingMask {...props} />
            </div>
            <Slider />
        </section>
    )
}