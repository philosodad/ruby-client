Feature: pairing with bitpay
  In order to access bitpay
  It is required that the library
  Is able to pair successfully

  Scenario: there is no local keyfile
    Given that there is no local keyfile
    And the user has a legitimate pairing code
    When the user pairs with bitpay
    Then the client will pair successfully
    And the keyfile will be saved locally
    And tokens will be saved locally

  Scenario: there is a local keyfile
    Given that there is a local keyfile
    And the user has a legitimate pairing code
    When the user pairs with bitpay
    Then the client will pair successfully
    And tokens will be saved locally

  Scenario: the client has no pairing code
    Given that there is a local keyfile
    And the user does not have a legitimate pairing code
    When the user pairs with bitpay
    Then they will recieve a pairing error

  Scenario: the client has bad keys
    Given that there is a bad local keyfile
    And the user has a legitimate pairing code
    When the users pairs with bitpay
    Then they will recieve a key error

