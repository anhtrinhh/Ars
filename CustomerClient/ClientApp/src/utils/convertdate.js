const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

export default function ConvertDate(date) {
    let strDate = null;
    if (date) {
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (month < 10) {
            month = "0" + month;
        }
        if (day < 10) {
            day = "0" + day;
        }
        strDate = `${date.getFullYear()}-${month}-${day}`;
    }
    return strDate;
}

export function GetDateStr(datestr) {
    let flightDate = new Date(datestr);
    return `${days[flightDate.getDay()]}, ${flightDate.getDate()}. ${months[flightDate.getMonth()]} ${flightDate.getFullYear()}`;
}

export function GetTimeStr(time) {
    let { hours, minutes } = time;
    if (hours < 10) {
        hours = "0" + hours;
    }
    if (minutes < 10) {
        minutes = "0" + minutes;
    }
    return `${hours}:${minutes}`;
}

export function SubtractTime(time1, time2) {
    let hours = 0;
    let minutes = 0;
    if (time1.hours >= time2.hours) {
        hours = time1.hours - time2.hours;
    } else {
        hours = 24 - (time2.hours - time1.hours);
    }
    if (time1.minutes >= time2.minutes) {
        minutes = time1.minutes - time2.minutes;
    } else {
        minutes = 60 - (time2.minutes - time1.minutes);
        hours--;
    }
    if (hours < 10) {
        hours = "0" + hours;
    }
    if (minutes < 10) {
        minutes = "0" + minutes;
    }
    return `${hours}:${minutes}`;
}