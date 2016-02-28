require 'bundler/setup'
require 'octokit'
require 'dotenv'
require 'erb'

Dotenv.load

client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_ACCESS_TOKEN'), auto_paginate: true)

repo_name, user_name, from, to = ARGV

events = client.user_events(user_name)
events_for_repo = events.select { |event| event.repo.name == repo_name }
events_within_period = events_for_repo.select do |event|
  event.created_at.to_date >= Date.parse(from) && event.created_at.to_date <= Date.parse(to)
end

rows = []
events_within_period.each do |event|
  row = {
    time: event.created_at,
    type: event.type.sub(/Event$/, '')
  }
  case event.type
  when 'CommitCommentEvent'
    sha = event.payload.comment.commit_id
    comment_url = event.payload.comment.html_url
    commit = client.commit(repo_name, sha)
    commit_subject = commit.commit.message.split($/).first
    row[:text] = commit_subject
    row[:url] = comment_url
  when 'IssueCommentEvent'
    issue_title = event.payload.issue.title
    comment_url = event.payload.comment.html_url
    row[:text] = issue_title
    row[:url] = comment_url
  when 'PullRequestReviewCommentEvent'
    pr_title = event.payload.pull_request.title
    comment_url = event.payload.comment.html_url
    row[:text] = pr_title
    row[:url] = comment_url
  end

  rows << row
end

erb = ERB.new(File.read('output.html.erb'))
output = erb.result(binding)
File.write('output.html', output)
`open output.html`
