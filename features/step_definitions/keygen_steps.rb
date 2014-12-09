require_relative 'step_helpers'

@token = nil
@error = nil

Given(/^that there is a local keyfile$/) do
  File.file?(BitPay::PRIVATE_KEY_PATH) ? true : create_key_file
end

Given(/^that there is no local keyfile$/) do
  File.file?(BitPay::PRIVATE_KEY_PATH) ? delete_key_file : true
end

When(/^the keyfile will be saved locally$/) do
  File.file?(BitPay::PRIVATE_KEY_PATH)
end

Given(/^that there is no token saved locally$/) do
  File.file?(BitPay::TOKEN_FILE_PATH) ? File.delete(BitPay::TOKEN_FILE_PATH) : true
end

When(/^tokens will be saved locally$/) do
  File.open(BitPay::TOKEN_FILE_PATH, 'r').read == JSON.generate(@token['data'][0])
end

When(/^the user pairs with BitPay with a valid pairing code$/) do
  claim_code = get_claim_code_from_server
  pem = BitPay::KeyUtils.generate_pem
  client = BitPay::Client.new(api_uri: ROOT_ADDRESS, pem: pem, insecure: true)
  @token = client.pair_pos_client(claim_code)
  @token['data'][0]['token'].length > 0
end

When(/^the fails to pair with BitPay because of an incorrect port$/) do
  pem = BitPay::KeyUtils.generate_pem
  address = ROOT_ADDRESS.split(':').slice(0,2).join(':') + ":999"
  client = BitPay::Client.new(api_uri: address, pem: pem, insecure: true)
  begin
    client.pair_pos_client("1ab2c34")
    raise "pairing unexpectedly worked"
  rescue => error
    @error = error
    true
  end
end

Given(/^the user has a bad pairing_code "(.*?)"$/) do |arg1|
    # This is a no-op, pairing codes are transient and never actually saved
end

Then(/^the user fails to pair with a semantically (?:in|)valid code "(.*?)"$/) do |code|
  pem = BitPay::KeyUtils.generate_pem
  client = BitPay::Client.new(api_uri: ROOT_ADDRESS, pem: pem, insecure: true)
  begin
    client.pair_pos_client(code)
    raise "pairing unexpectedly worked"
  rescue => error
    @error = error
    true
  end
end

Then(/^they will recieve a (.*?) matching "(.*?)"$/) do |error_class, error_message|
  raise "Error: #{@error.class}, message: #{@error.message}" unless Object.const_get(error_class) == @error.class && @error.message.include?(error_message)
end

