import "./style.scss";

export default function Footer(){
    return (
        <footer className="footer">
            <div className="footer-top">
                <div className="container">
                    <div className="footer-top__wrapper">
                        <div className="footer-top__col">
                            <ul>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                            </ul>
                            <ul>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                                <li>
                                    <a href="/" target="_blank">Introduce about the company</a>
                                </li>
                            </ul>
                        </div>
                        <div className="footer-top__col ">
                            <ul>
                                <li>
                                    <p>Suggestions, service complaints</p>
                                    <a href="tel:18008888" className="phone-number">1800 8888</a>
                                </li>
                                <li>
                                    <p>Payment assistance</p>
                                    <i className="png-visa-icon png-icon"></i>
                                    <i className="png-mastercard-icon png-icon"></i>
                                </li>
                            </ul>
                            <ul>
                                <li className="social">
                                    <p>Contact</p>
                                    <a href="/" target="_blank">
                                        <i className="png-icon png-facebook-icon"></i>
                                    </a>
                                    <a href="/" target="_blank">
                                        <i className="png-icon png-instagram-icon"></i>
                                    </a>
                                    <a href="/" target="_blank">
                                        <i className="png-icon png-youtube-icon"></i>
                                    </a>
                                    <a href="/" target="_blank">
                                        <i className="png-icon png-twitter-icon"></i>
                                    </a>
                                </li>
                                <li>
                                    <p>Download mobile app</p>
                                    <div className="download-app">
                                        <span>
                                            <i className="png-icon png-qr-icon"></i>
                                        </span>
                                        <span>
                                            <a href="/">
                                                <i className="png-icon png-appstore-icon"></i>
                                            </a>
                                            <a href="/">
                                                <i className="png-icon png-googlestore-icon"></i>
                                            </a>
                                        </span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div className="footer-bottom">
                © 2020 ARS Airways Copyright. All Rights Reserved.
            </div>
        </footer>
    )
}