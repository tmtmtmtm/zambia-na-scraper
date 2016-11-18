# frozen_string_literal: true
require 'scraped_page'

class MemberPage < ScrapedPage
  field :id do
    url.to_s.split('/').last
  end

  field :photo do
    noko.css('.panels-flexible-region-1-picture img/@src').first.text rescue ""
  end

  field :email do
    noko.css('.field-name-field-email .field-item a').map(&:text).join(';')
  end

  field :birth_date do
    noko
      .css('.field-name-field-date .field-item .date-display-single/@content')
      .text
      .split('T')
      .first
  end

  field :term do
    2016
  end
end
