require 'capybara/poltergeist'
require 'pry'

require File.join File.dirname(__FILE__), '..', '..', 'lib', 'bitpay', 'client.rb'
require File.join File.dirname(__FILE__), '..', '..', 'lib', 'bitpay', 'key_utils.rb'
require File.join File.dirname(__FILE__), '..', '..', 'lib', 'bitpay.rb'
require_relative '../../config/constants.rb'
require_relative '../../config/capybara.rb'

#
## Test Variables
#
PEM = "-----BEGIN EC PRIVATE KEY-----\nMHQCAQEEICg7E4NN53YkaWuAwpoqjfAofjzKI7Jq1f532dX+0O6QoAcGBSuBBAAK\noUQDQgAEjZcNa6Kdz6GQwXcUD9iJ+t1tJZCx7hpqBuJV2/IrQBfue8jh8H7Q/4vX\nfAArmNMaGotTpjdnymWlMfszzXJhlw==\n-----END EC PRIVATE KEY-----\n"

PUB_KEY = '038d970d6ba29dcfa190c177140fd889fadd6d2590b1ee1a6a06e255dbf22b4017'
CLIENT_ID = "TeyN4LPrXiG5t2yuSamKqP3ynVk3F52iHrX"


def create_key_file
  BitPay::KeyUtils.generate_pem
  true
end

def delete_key_file
  File.delete(BitPay::PRIVATE_KEY_PATH)
  true
end

def get_claim_code_from_server
  Capybara::visit ROOT_ADDRESS
  if logged_in
    Capybara::click_link('Dashboard')
  else
    log_in
  end
  Capybara::click_link "My Account"
  Capybara::click_link "API Tokens", match: :first
  Capybara::find(".token-access-new-button").find(".btn").find(".icon-plus").click
  sleep 0.25
  Capybara::click_button("Add Token")
  Capybara::find(".token-claimcode", match: :first).text
end

def log_in
  Capybara::click_link('Login')
  Capybara::fill_in 'email', :with => TEST_USER
  Capybara::fill_in 'password', :with => TEST_PASS
  Capybara::click_button('loginButton')
end

def logged_in
  Capybara::has_link?('Dashboard')
end
