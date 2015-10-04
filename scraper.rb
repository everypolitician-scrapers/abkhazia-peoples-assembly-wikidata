#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'set'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'


def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end

def en_wikinames(url)
  noko = noko_for(url)
  noko.xpath('//table[.//th[contains(., "Name")]]//tr[td]').map { |tr| 
    tr.css('a').first }.reject { |a| a.attr('class') == 'new' }.map { |a| a.attr('title') }
end

def ab_wikinames(url)
  noko = noko_for(url)
  col = 'Адепутат'
  noko.xpath('//table[.//th[contains(., "%s")]]//tr[td]//td[3]//a[not(@class="new")]/@title' % col).map(&:text)
end

def ru_wikinames(url)
  noko = noko_for(url)
  col = 'Депутат'
  noko.xpath('//table[.//th[contains(., "%s")]]//tr[td]//td[3]//a[not(@class="new")]/@title' % col).map(&:text)
end

enids = WikiData.ids_from_pages('en', en_wikinames('https://en.wikipedia.org/wiki/5th_convocation_of_the_People%27s_Assembly_of_Abkhazia')).map(&:last) 
abids = WikiData.ids_from_pages('ab', ab_wikinames('https://ab.wikipedia.org/wiki/%D0%90%D2%A7%D1%81%D0%BD%D1%8B_%D0%96%D3%99%D0%BB%D0%B0%D1%80_%D0%A0%D0%B5%D0%B8%D0%B7%D0%B0%D1%80%D0%B0')).map(&:last)
ruids = WikiData.ids_from_pages('ru', ru_wikinames('https://ru.wikipedia.org/wiki/%D0%9D%D0%B0%D1%80%D0%BE%D0%B4%D0%BD%D0%BE%D0%B5_%D1%81%D0%BE%D0%B1%D1%80%D0%B0%D0%BD%D0%B8%D0%B5_%D0%A0%D0%B5%D1%81%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%B8_%D0%90%D0%B1%D1%85%D0%B0%D0%B7%D0%B8%D1%8F')).map(&:last)

ids = (enids + abids + ruids).uniq


ids.each do |id|
  data = WikiData::Fetcher.new(id: id).data rescue nil
  unless data
    warn "No data for #{p}"
    next
  end
  ScraperWiki.save_sqlite([:id], data)
end
