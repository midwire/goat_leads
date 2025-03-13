# frozen_string_literal: true

namespace :db do
  namespace :seed do
    desc 'Seed all tables'
    task all: :environment do
      load(Rails.root.join('db/seeds.rb'))
    end

    desc 'Seed a specific table'
    task :table, [:table_name] => :environment do |_, args|
      table_name = args[:table_name]
      unless table_name
        puts 'Please specify a table name. Example: rake db:seed:table[users]'
        exit
      end

      seed_file = Rails.root.join('db', 'seeds', "#{table_name}.rb")
      if File.exist?(seed_file)
        puts "Seeding #{table_name}..."
        load(seed_file)
        puts "#{table_name.capitalize} seeded."
      else
        puts "No seed file found for '#{table_name}'."
      end
    end

    desc 'Seed users table'
    task users: :environment do
      load(Rails.root.join('db/seeds/users.rb'))
    end

    desc 'Seed faqs table'
    task faqs: :environment do
      load(Rails.root.join('db/seeds/faqs.rb'))
    end

    desc 'Seed leads table'
    task leads: :environment do
      load(Rails.root.join('db/seeds/leads.rb'))
    end

    desc 'Seed lead_orders table'
    task lead_orders: :environment do
      load(Rails.root.join('db/seeds/lead_orders.rb'))
    end
  end
end
