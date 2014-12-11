Feature: creating an invoice
  The user won't get any money 
  If they can't
  Create Invoices

  Background:
    Given the user is paired with BitPay

  Scenario Outline: The request is correct
    When the user creates an invoice for <price> <currency>
    Then they should recieve an invoice in response for <price> <currency>
  Examples:
    | price    | currency |
    | "500.23" | "USD"    |
    | "300.21" | "EUR"    |

  Scenario Outline: The invoice contains illegal characters
    When the user creates an invoice for <price> <currency>
    Then they should receive a BitPay::ArgumentError matching "Illegal Argument"
  Examples:
    | price    | currency  |
    | "500,23" | "USD"     |
    | "300.21" | "EaUR"    |
    | ""       | "USD"     |
    | "Ten"    | "USD"     |
    | "100"    | ""        |

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
    Then they will receive a BitPay Error matching "500: Invoice not created due to account limits, please check your approval levels"

  ### these errrors are quite generic, do we want to capture these bad values before making a request
  Scenario: The currency code is invalid
    Given there is a valid token and keyfile
    When the user tries to create an invoice with an invalid currency
    Then they will receive a BitPay Error matching "500: Bitcoin address not available, try again later"

  Scenario: The price is invalid
    Given there is a valid token and keyfile
    When the user tries to create an invoice with an invalid price
    Then they will receive a BitPay Error matching "500: Bitcoin address not available, try again later"
