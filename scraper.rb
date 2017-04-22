#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'scraperwiki'
require 'require_all'
require_rel 'lib'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

BASE = 'http://www.parliament.gov.zm'

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil

# We should really extract these from the 'Next' links
pages = [
  '/members-of-parliament',
  '/members-of-parliament/page/1/0',
  '/members-of-parliament/page/2/0',
]

added = 0
pages.each do |page|
  url = URI.join(BASE, page).to_s
  warn "Fetching #{url}"
  (scrape url => MembersPage).member_rows.each do |row|
    mp_page = scrape row.source => MemberPage
    data = row.to_h
              .merge(mp_page.to_h)
              .merge(source: url, term: 2016)
    ScraperWiki.save_sqlite(%i(name term), data)
    added += 1
  end
end
puts "  Added #{added}"
