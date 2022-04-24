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
    pp reader.jsons[0]
    records = reader.extract_payment_records()
    assert_equal(records.length, 2)
    first_record = records[0]
    assert_instance_of(PaymentRecord, first_record)
    assert_equal(58310, first_record.price)
    assert_equal("定期代", first_record.goods)
    # 次はtimestampの扱いだな。"ts": "1648614270.636359"ってなんなの？？
  end
end
