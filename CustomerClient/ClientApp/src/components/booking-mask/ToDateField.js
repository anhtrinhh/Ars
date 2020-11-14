import DatePicker from "react-datepicker";
import "./style/fromdatefield.scss";
import { useRef, useEffect } from "react";

export default function ToDateField({ focus, setFieldFocus, date, minDate, setChooseDate }) {
    let datepickerRef = useRef(null);
    useEffect(() => {
        if (focus) {
            datepickerRef.current.setFocus()
        }
    })
    const handleChange = (date) => {
        setChooseDate(date, "TO");
    }
    const handleClose = () => {
        setFieldFocus("to");
    }
    return (
        <div className="tab-search__form-field--1 no-position">
            <label>Return date</label>
            <DatePicker
                selected={date}
                dateFormat="dd/MM/yyyy"
                placeholderText="Choose a date"
                monthsShown={2}
                onFocus={() => window.scrollTo(0, 100)}
                ref={datepickerRef}
                onChange={handleChange}
                onCalendarClose={handleClose}
                minDate={minDate}
                selectsEnd
                startDate={minDate}
                endDate={date}
            />
        </div>
    )
}