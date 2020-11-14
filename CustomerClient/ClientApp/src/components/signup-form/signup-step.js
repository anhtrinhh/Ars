import { Step } from "semantic-ui-react";

export default function SignUpStep({ step }) {
    return (
        <Step.Group size="mini" widths={3}>
            <Step active={step === 1} completed={step !== 1}>
                <Step.Content>
                    <Step.Title>Basic information</Step.Title>
                    <Step.Description>Fill in your basic information</Step.Description>
                </Step.Content>
            </Step>

            <Step disabled={step < 2} active={step === 2} completed={step > 2}>
                <Step.Content>
                    <Step.Title>Contact information</Step.Title>
                    <Step.Description>Fill in your contact information</Step.Description>
                </Step.Content>
            </Step>

            <Step disabled={step < 3} active={step === 3}>
                <Step.Content>
                    <Step.Title>Confirm information</Step.Title>
                </Step.Content>
            </Step>
        </Step.Group>
    )
}