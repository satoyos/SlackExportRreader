require 'minitest/autorun'
require_relative '../slack_export_reader'

class TestSlackExportReader < Minitest::Test
  def test_インスタンスを作成できる
    reader = SlackExportReader.new(folder_path: 'test/test_data/dev')
    assert reader != nil
    assert_instance_of(SlackExportReader, reader)
  end

  def test_対象フォルダのファイル数を取得できる
    reader = SlackExportReader.new(folder_path: 'test/test_data/dev')
    assert_equal(reader.files.length, 2)
    reader.load_json_from_files
  end

  def test_extract_payment_records
    reader = SlackExportReader.new(folder_path:'test/test_data/foobar-paid')
    assert_equal(reader.files.length, 2)
    reader.load_json_from_files
    assert_equal(2, reader.jsons.length)
    # pp reader.jsons[0]
    records = reader.extract_payment_records(first_name: "John")
    assert_equal(records.length, 2)
    first_record = records[0]
    assert_instance_of(PaymentRecord, first_record)
    assert_equal(58310, first_record.price)
    assert_equal("定期代", first_record.goods)
    assert_equal(2022, first_record.date.year)
  end

  def test_extract_payment_records_without_goods
    # when
    reader = SlackExportReader.new(folder_path: 'test/test_data/whtiout-split-space')
    # then
    assert_equal(1, reader.files.length)
    # when
    reader.load_json_from_files
    records = reader.extract_payment_records(first_name: "John")
    # then
    assert_equal(1, records.size)
    assert_equal('ご飯', records[0].goods)
    assert_equal(559, records[0].price)
  end

  def test_extract_payment_records_only_price
    # when
    reader = SlackExportReader.new(folder_path: 'test/test_data/price_only_data')
    # then
    assert_equal(1, reader.files.length)
    # when
    reader.load_json_from_files
    records = reader.extract_payment_records(first_name: "John")
    # then
    assert_equal(1, records.size)
    rec = records[0]
    assert_equal('ご飯', rec.goods)
  end

  def test_extract_payment_records_multi_prices
    # when
    reader = SlackExportReader.new(folder_path: 'test/test_data/multi_prices')
    # then
    assert_equal(1, reader.files.length)
    # when
    reader.load_json_from_files
    records = reader.extract_payment_records(first_name: "John")
    # then
    assert_equal(2, records.size)
    rec = records[1]
    assert_equal(900, rec.price)
  end

  def test_extract_payment_records_in_range()
    reader = SlackExportReader.new(folder_path:'test/test_data/foobar-paid')
    reader.load_json_from_files
    records = reader.extract_payment_records(first_name: "John", from: DateTime.new(2022, 4, 1))
    assert_equal(1, records.length)
    assert_equal(4, records[0].date.month)
    records = reader.extract_payment_records(first_name: "John", to: DateTime.new(2022, 4, 1))
    assert_equal(1, records.length)
    assert_equal(3, records[0].date.month)
  end

  def test_extract_payment_record_with_default_name_in_ENV
    ENV['SPENDER'] = "John"
    reader = SlackExportReader.new(folder_path:'test/test_data/foobar-paid')
    reader.load_json_from_files
    records = reader.extract_payment_records()
    assert_equal(2, records.count)
  end

end

# あとは、有効なログを拾ってくる際に見ているfirst_nameを変更できるようにする
# 今は、Johnをハードコーディングで指定してる
