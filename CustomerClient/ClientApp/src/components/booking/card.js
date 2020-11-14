import React from "react"
import { Form } from "semantic-ui-react";
import { connect } from "react-redux";
import { SetBankCard } from "../../actions";

const monthOption = [];
const yearOption = [];
for (let i = 1; i <= 12; i++) {
    if (i < 10) {
        monthOption.push({
            key: i, text: "0" + i, value: i
        })
    } else {
        monthOption.push({
            key: i, text: i, value: i
        })
    }
}
let date = new Date();
for (let i = date.getFullYear(); i <= date.getFullYear() + 20; i++) {
    yearOption.push({
        key: i, text: i, value: i
    })
}

class Card extends React.Component {
    handleChangeExpireMonth = (evt, data) => {
        this.props.setBankCard({
            expireMonth: data.value
        })
    }

    handleChangeExpireYear = (evt, data) => {
        this.props.setBankCard({
            expireYear: data.value
        })
    }

    handleChangeText = evt => {
        let name = evt.target.name;
        let value = evt.target.value;
        if (name === "cardNumber") {
            value = value.replace(/[a-z]/ig, '')
                .replace(/(\d{4})(?=(\d)+(?!\d))/g, "$1\t");
        } else if (name === "safelyCode") {
            value = value.replace(/[a-z]/ig, '')
                .slice(0, 3);
        }
        this.props.setBankCard({
            [name]: value
        })
    }
    render() {
        let { cardNumber, expireMonth, expireYear, cardHolder, safelyCode } = this.props.bankCard;
        let { errCardNumber, errExpireMonth, errExpireYear, errCardHolder, errSafelyCode } = this.props.errorBankCard;
        return (
            <div className="bank-card">
                <div className="card-col">
                    <Form>
                        <Form.Field>
                            <label>Card Number*</label>
                            <input type="text"
                                placeholder="4242 4242 4242 4242"
                                value={cardNumber}
                                name="cardNumber"
                                onChange={this.handleChangeText}
                            />
                            {errCardNumber ? (<span className="card-error">{errCardNumber}</span>) : ''}
                        </Form.Field>
                        <label>Expiration Date*</label>
                        <Form.Group>
                            <div className="select-expire">
                                <Form.Select options={monthOption}
                                    placeholder="Month"
                                    name="expireMonth"
                                    value={expireMonth}
                                    onChange={this.handleChangeExpireMonth}
                                />
                                {errExpireMonth ? (<span className="card-error">{errExpireMonth}</span>) : ''}
                            </div>
                            <div className="select-expire">
                                <Form.Select options={yearOption}
                                    placeholder="Year"
                                    name="expireYear"
                                    value={expireYear}
                                    onChange={this.handleChangeExpireYear}
                                />
                                {errExpireYear ? (<span className="card-error">{errExpireYear}</span>) : ''}
                            </div>
                        </Form.Group>
                        <Form.Field>
                            <label>Cardholder Name*</label>
                            <input type="text"
                                placeholder="Cardholder Name"
                                value={cardHolder}
                                name="cardHolder"
                                onChange={this.handleChangeText}
                            />
                            {errCardHolder ? (<span className="card-error">{errCardHolder}</span>) : ''}
                        </Form.Field>
                    </Form>
                </div>
                <div className="card-col">
                    <div className="magnetic-stripe"></div>
                    <div className="safe-code">
                        <label>Safety code*</label>
                        <div className="code-input">
                            <label>The last 3 digits displayed on the back of your card</label>
                            <div>
                                <input type="text"
                                    placeholder="CVV"
                                    value={safelyCode}
                                    name="safelyCode"
                                    onChange={this.handleChangeText}
                                />
                                {errSafelyCode ? (<p className="card-error">{errSafelyCode}</p>) : ''}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}


const mapStateToProps = state => {
    return {
        bankCard: state.BankCard,
        errorBankCard: state.ErrorBankCard
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setBankCard(bankCard) {
            dispatch(SetBankCard(bankCard))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(Card);