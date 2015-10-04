#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'
require 'nokogiri'
require 'open-uri'
require 'pry'

def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end

def en_wikinames(url)
  noko = noko_for(url)
  noko.xpath('//table[.//th[contains(., "Name")]]//tr[td]').map { |tr| 
    tr.css('a').first }.reject { |a| a.attr('class') == 'new' }.map { |a| a.attr('title') }
end

en_names = en_wikinames('https://en.wikipedia.org/wiki/5th_convocation_of_the_People%27s_Assembly_of_Abkhazia')
ids = WikiData.ids_from_pages('en', en_names)

ids.each_with_index do |p, i|
  data = WikiData::Fetcher.new(id: p.last).data('fr') rescue nil
  unless data
    warn "No data for #{p}"
    next
  end
  puts data
  ScraperWiki.save_sqlite([:id], data)
end
