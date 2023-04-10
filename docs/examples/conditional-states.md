# Conditional State 
 [Conditional State on Github](https://github.com/direktiv/direktiv-examples/tree/main/conditional-states)

This example demonstrates the use of a switch state to conditional transition to different states based on a jq expression.  To show this, the example below is a flow that either approves or rejects a loan depending on the provided credit score and required minimum credit score.


```yaml title="Simple Switch Statement"
description: |
  Conditionally transition to states depending if input credit score is higher
  or lower than creditMinRequired.

states:
  - id: validate-input
    type: validate
    schema:
      type: object
      required:
      - creditScore
      - creditMinRequired
      properties:
        creditMinRequired:
          type: number
          title: Minimum credit score
          description: minimum credit score required for approval 
          default: 500
        creditScore:
          type: number
          description: credit score of user
          title: Credit Score
    transition: check-credit

    #
    # Check if the user's threshold is above minimum credit requirements.
    # If credit score meets requirements transition to approve-loan. Otherwise
    # transition to reject-loan.
    #
  - id: check-credit
    type: switch
    conditions:
    - condition: jq(.creditScore > .creditMinRequired)
      transition: approve-loan
    defaultTransition: reject-loan
  - id: reject-loan
    type: noop
    transform: 'jq({ "msg": "You have been rejected for this loan" })'
  - id: approve-loan
    type: noop
    transform: 'jq({ "msg": "You have been approved for this loan" })'
```


```json title="Input"
{
  "creditMinRequired": 500,
  "creditScore": 600
}
```

```json title="Output"
{
  "msg": "You have been approved for this loan"
}
```

