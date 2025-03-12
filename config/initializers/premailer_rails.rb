# frozen_string_literal: true

Premailer::Adapter.use = :nokogiri_fast
Premailer::Rails.config.merge!(preserve_styles: true, remove_ids: true)
