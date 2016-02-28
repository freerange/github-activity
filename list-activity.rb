require 'bundler/setup'
require 'octokit'
require 'dotenv'

Dotenv.load

client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_ACCESS_TOKEN'))
