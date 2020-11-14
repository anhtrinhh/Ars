import DatePicker from "react-datepicker";
import "./style/fromdatefield.scss";
import { useRef, useEffect } from "react";

export default function FromDateField({ focus, setFieldFocus, setChooseDate, date, minDate, maxDate}) {
    let datepickerRef = useRef(null);
    useEffect(() => {
        if (focus) {
            datepickerRef.current.setFocus();
        }
    });
    const handleChange = (date) => {
        setChooseDate(date, "FROM");
    }
    const handleClose = () => {
        setFieldFocus("from");
    }
    return (
        <div className="tab-search__form-field--1 no-position">
            <label>Departure date</label>
            <DatePicker
                dateFormat="dd/MM/yyyy"
                selected={date}
                placeholderText="Choose a date"
                monthsShown={2}
                onFocus={() => window.scrollTo(0, 100)}
                ref={datepickerRef}
                onChange={handleChange}
                onCalendarClose={handleClose}
                minDate={minDate}
                maxDate={maxDate}
                selectsStart
                startDate={date}
                endDate={maxDate}
            />
        </div>
    )
}