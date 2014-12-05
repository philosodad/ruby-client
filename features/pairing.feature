Feature: pairing with bitpay
  In order to access bitpay
  It is required that the library
  Is able to pair successfully

  Scenario: there is no local keyfile
    Given that there is no local keyfile
    When the user pairs with BitPay with a valid pairing code
    Then the client will pair successfully
    And the keyfile will be saved locally
    And tokens will be saved locally

  Scenario: there is a local keyfile
    Given that there is a local keyfile
    When the user pairs with BitPay with a valid pairing code
    Then the client will pair successfully
    And tokens will be saved locally

  Scenario: the client has a bad pairing code
    Given that there is a local keyfile
    When the user pairs with BitPay with a bad pairing code
    Then they will recieve a BitPay Error matching "400: Unable to create token" 

  Scenario: the client has no pairing code
    Given that there is a local keyfile
    When the user pairs with BitPay with no pairing code
    Then they will recieve an Argument Error matching "wrong number of arguments" 

  Scenario: the client has bad keys
    Given that there is a bad local keyfile
    When the user pairs with BitPay with a valid pairing code
    Then they will recieve a BitPay Error matching "400: Unable to create token" 

  Scenario: the client has an API key
    Given that the client has a local keyfile
    When the user pairs with bitpay using an API key
    Then they will recieve a BitPay Error matching "use a pairing code"

  Scenario: the client has a bad port configuration to a closed port
    Given that there is a local keyfile
    And the configuration ssl port is incorrect
    And the incorrect port is not an open communication port
    When the user pairs with BitPay with a valid pairing code
    Then they will recieve an error "408: Request timeout, please check your port"

  Scenario: the client has a bad port configuration to an open port
    Given that there is a local keyfile
    And the configuration ssl port is incorrect
    And the incorrect port is an open communication port
    When the user pairs with BitPay with a valid pairing code
    Then they will recieve an error "Error"
