require "active_hash_sync/version"
require "active_record"
require "active_hash"

module ActiveHashSync
  def self.collect_active_hash_classes
    active_hash_classes = []

    Object.constants.each do |c|
      klass = Object.const_get(c)

      begin
        if klass.ancestors.any? { |k| k == ActiveHash::Base }
          active_hash_classes << klass
        end
      rescue NoMethodError
        # ignore IO error
      end
    end

    active_hash_classes
  end

  def self.sync!
    collect_active_hash_classes.each { |klass| Mapper.new(klass).call! }
  end

  def self.become_active_record_model(active_hash_class:)
    Class.new(ActiveRecord::Base) do
      self.table_name = ActiveHashSync.table_name_for(active_hash_class: active_hash_class)
    end
  end

  def self.table_name_for(active_hash_class:)
    "active_hash_#{active_hash_class.to_s.downcase}"
  end

  class Mapper
    def initialize(active_hash_class)
      @active_hash_class = active_hash_class

      detect_column_informations
    end

    def call!
      table_name = ActiveHashSync.table_name_for(active_hash_class: @active_hash_class)
      columns = @columns

      ActiveRecord::Schema.define do
        create_table table_name, force: true do |t|
          columns.each do |name, type|
            next if name == :id # primary key, skip

            # t.string :field_name
            t.send(type, name)
          end
        end
      end

      active_record_model = ActiveHashSync.become_active_record_model(active_hash_class: @active_hash_class)

      @active_hash_class.all.each do |active_hash_data|
        active_record_model.create!(active_hash_data.attributes)
      end
    end

    private

    def detect_column_informations
      # column_name => type
      @columns = {}

      @active_hash_class.all.each do |row|
        row.attributes.each do |column_name, value|
          next if value.nil?

          type =
            case value
            when String then :string
            when Integer then :integer
            end
          @columns[column_name] = type
        end
      end
    end
  end
end
