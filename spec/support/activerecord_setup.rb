# frozen_string_literal: true

require "dotenv/load"
require "active_record"

ActiveRecord::Base.logger = Logger.new($stderr, level: Logger::WARN)
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  encoding: "unicode",
  database: ENV["POSTGRES_DB"],
  host: ENV["POSTGRES_HOST"],
  username: ENV["POSTGRES_USER"],
  password: ENV["POSTGRES_PASSWORD"],
  port: ENV["POSTGRES_PORT"],
  timeout: 5000
)

ActiveRecord::Schema.define do
  self.verbose = false

  drop_table :albums, if_exists: true
  create_table :albums do |t|
    t.column :title, :string
    t.column :tracks, :integer, array: true, null: false, default: []
  end

  drop_table :tracks, if_exists: true
  create_table :tracks do |t|
    t.column :track_number, :integer
    t.column :title, :string
  end
end

class Album < ActiveRecord::Base
  include RecordList
  record_list :tracks, class_name: "Track"
end

class Track < ActiveRecord::Base
  include RecordList
  has_and_belongs_to_record_lists :albums, inverse_of: :tracks, class_name: "Album"
end
