export default function FormatString(str) {
    if(str) {
       str = str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }
    return str;
}