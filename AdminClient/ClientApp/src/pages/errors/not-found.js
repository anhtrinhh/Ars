import { Link } from 'react-router-dom';
import "./style.scss";

export default function NotFound() {
    return (
        <div className="content-wrapper">
            <div className="error-wrapper">
                <h1>Oops!</h1>
                <h2>404 - page not found.</h2>
                <p>The page you are looking for may have been deleted or is temporarily unavailable.</p>
                <Link to="/">Return to home page</Link>
            </div>
        </div>
    )
}