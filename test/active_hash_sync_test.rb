require "test_helper"
require_relative "fixtures/post"
require_relative "fixtures/country"

class ActiveHashSyncTest < Minitest::Test
  DATABASE = "test/database.sqlite3"
  ACTIVE_HASH_CLASSES = [Post, Country]

  def setup
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: DATABASE)
  end

  def teardown
    File.delete(DATABASE) if File.exist?(DATABASE)
  end

  def test_that_it_has_a_version_number
    refute_nil ::ActiveHashSync::VERSION
  end

  def test_mapper
    mapper = ActiveHashSync::Mapper.new(Post)

    mapper.call!

    synced_table = ActiveHashSync.become_active_record_model(active_hash_class: Post)

    assert_equal "piyo", synced_table.find(1).name
    assert_equal "fuga", synced_table.find(2).name
  end

  def test_collect_active_hash_classes
    classes = ActiveHashSync.collect_active_hash_classes

    assert_equal ACTIVE_HASH_CLASSES.count, classes.count

    ACTIVE_HASH_CLASSES.each do |k|
      assert classes.include? k
    end
  end

  def test_sync
    ActiveHashSync.sync!
  end
end
