import { Link } from "react-router-dom";
import { Swiper, SwiperSlide } from 'swiper/react';
import SwiperCore, { Navigation, Pagination, Autoplay, A11y } from 'swiper';
import 'swiper/swiper.scss';
import 'swiper/components/navigation/navigation.scss';
import 'swiper/components/pagination/pagination.scss';
import "./style.scss";

import Image1 from "./image1.jpg";
import Image2 from "./image2.jpg";
import Image3 from "./image3.jpg";
import Image4 from "./image4.jpg";

SwiperCore.use([Navigation, Pagination, Autoplay, A11y]);
export default function Slider(){
    return (
        <div className="slider">
            <Swiper
                autoplay={{
                    delay: 8000,
                    disableOnInteraction: false,
                }}
                loop={true}
                navigation
                pagination={{
                    clickable: true,
                    renderBullet: function (index, className) {
                        return `<span class="${className}">Title of article</span>`;
                    },
                }}
            >
                {[Image1, Image2, Image3, Image4].map((val, ix) => {
                    return (
                        <SwiperSlide key={ix}>
                            <div className="slider__slide">
                                <img src={val} alt="Test Slider" />
                                <div className="slider__shadow"></div>
                                <div className="container">
                                    <div className="slider-content">
                                        <Link to="/">Detail</Link>
                                    </div>
                                </div>
                            </div>
                        </SwiperSlide>
                    )
                })}
            </Swiper>
        </div>
    )
}