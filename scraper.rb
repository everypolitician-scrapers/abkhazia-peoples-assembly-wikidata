#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

en_names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: "https://en.wikipedia.org/wiki/5th_convocation_of_the_People's_Assembly_of_Abkhazia",
  xpath: '//table[.//th[contains(., "Name")]]//tr[td]//td[3]//a[not(@class="new")]/@title'
)

en_names2 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: "https://en.wikipedia.org/wiki/5th_convocation_of_the_People's_Assembly_of_Abkhazia",
  xpath: '//table[.//th[contains(., "Name")]]//tr[td]//td[1]//a[not(@class="new")]/@title'
)

ab_names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ab.wikipedia.org/wiki/Аҧсны_Жәлар_Реизара',
  xpath: '//table[.//th[contains(., "Адепутат")]]//tr[td]//td[3]//a[not(@class="new")]/@title',
)

ru_names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ru.wikipedia.org/wiki/Народное_собрание_Республики_Абхазия',
  xpath: '//table[.//th[contains(., "Депутат")]]//tr[td]//td[3]//a[not(@class="new")]/@title',
)

EveryPolitician::Wikidata.scrape_wikidata(names: { en: en_names | en_names2, ab: ab_names, ru: ru_names })
