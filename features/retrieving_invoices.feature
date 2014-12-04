Feature: retrieving an invoice
  The user may want to retrieve invoices
  So that they can view them

  Scenario: The request is correct
    Given that an invoice "abcde" with attributes <list of attributes> exists on the server
    When the user retrieves the invoice "abcde"
    Then they will receive a complete invoice with attributes <list of attributes>

  Scenario: 
    Given that no invoice "abcde" exists on the server
    When the user retrieves the invoice "abcde"
    Then they will receive a BitPay Error matching "500: Object not found"
