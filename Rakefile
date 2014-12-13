require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'capybara'
require 'capybara/poltergeist'
require 'mongo'
require 'cucumber'
require 'cucumber/rake/task'
require_relative 'config/constants.rb'
require_relative 'config/capybara.rb'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format pretty"
end

desc "Bitpay Tasks"
namespace :bitpay do

  desc "Clear all claim codes from the test server."
  task :clear_claim_codes do
    puts "clearing claim codes"
    Capybara.visit ROOT_ADDRESS
    Capybara.click_link('Login')
    Capybara.fill_in 'email', :with => TEST_USER
    Capybara.fill_in 'password', :with => TEST_PASS
    Capybara.click_button('loginButton')
    Capybara.click_link "My Account"
    Capybara.click_link "API Tokens", match: :first
    while Capybara.page.has_selector?(".token-claimcode") || Capybara.page.has_selector?(".token-requiredsins-key") do
      Capybara.page.find(".api-manager-actions-edit", match: :first).click
      Capybara.page.find(".api-manager-actions-revoke", match: :first).click
      Capybara.click_button("Confirm Revoke")
      # this back and forth bit is here because no other reload mechanism worked, and without it the task errors out: either because it can't find the revoke button or it finds multiple elements at each click point
      Capybara.page.go_back
      Capybara.click_link "API Tokens", match: :first
    end
    puts "claim codes cleared"
  end

  desc "Clear rate limiters from local mongo host"
  task :clear_rate_limiters do
    puts "clearing rate limiters"
    client = Mongo::MongoClient.new
    db     = client['bitpay-dev']
    coll   = db['ratelimiters']
    coll.remove()
    puts "rate limiters cleared"
  end

  desc "Clear local pem and token file"
  task :clear_local_files do
    puts "clearing local files"
    HOME_DIR = File.join(Dir.home, '.bitpay')
    KEY_FILE = File.join(HOME_DIR, 'bitpay.pem')
    TOKEN_FILE = File.join(HOME_DIR, 'tokens.json')
    File.delete(KEY_FILE) if File.file?(KEY_FILE)
    File.delete(TOKEN_FILE) if File.file?(TOKEN_FILE)
    puts "local files cleared"
  end

  desc "Run specs and clear claim codes and rate_limiters."
  task :spec_clear => ['spec', 'clear_claim_codes', 'clear_rate_limiters']
  task :tests_clear => ['spec', 'clear_rate_limiters', 'features', 'clear_local_files', 'clear_claim_codes', 'clear_rate_limiters']

end
