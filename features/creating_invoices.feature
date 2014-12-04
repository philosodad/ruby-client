Feature: creating an invoice
  The user won't get any money 
  If they can't
  Create Invoices

  Scenario: The request is correct
    Given there is a valid token and keyfile
    When the user tries to create an invoice with price and currency
    Then they should recieve an invoice in response with price and currency and status

  Scenario: The invoice is incomplete
    Given there is a valid token and keyfile
    When the user tries to create an invoice without (price or currency)
    Then they will receive an Argument Error matching "missing keyword: "

  Scenario: The token is invalid
    Given there is an invalid token
    When the user tries to create an invoice with price and currency
    Then they will receive a BitPay Error matching "500: Invalid token"

  Scenario: The key is invalid 
    Given there is an invalid key
    When the user tries to create an invoice with price and currency
    Then they will receive a BitPay Error matching "500: Invalid signature"

  Scenario: The invoice amount exceeds the tier level
    Given there is a valid token and keyfile
    When the user tries to create an invoice which exceeds their tier
    Then they will receive a BitPay Error "error message"

  ### these errrors are quite generic, do we want to capture these bad values before making a request
  Scenario: The currency code is invalid
    Given there is a valid token and keyfile
    When the user tries to create an invoice with an invalid currency
    Then they will receive a BitPay Error matching "500: Bitcoin address not available, try again later"

  Scenario: The price is invalid
    Given there is a valid token and keyfile
    When the user tries to create an invoice with an invalid price
    Then they will receive a BitPay Error matching "500: Bitcoin address not available, try again later"
