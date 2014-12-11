When(/^the user (?:tries to |)creates? an invoice (?:for|without) "(.*?)" (?:or |)"(.*?)"$/) do |price, currency|
  client = BitPay::Client.new(api_uri: ROOT_ADDRESS, insecure: true)
  id = SecureRandom.uuid
  @response = client.create_invoice(id: id, price: price, currency: currency)
end

Then(/^they should recieve an invoice in response for "(.*?)" "(.*?)"$/) do |price, currency|
  raise "#{@response['price']} != #{price} or #{@response['currency']} != #{currency}" unless (price == @response['price'].to_s && currency == @response['currency'])
end

