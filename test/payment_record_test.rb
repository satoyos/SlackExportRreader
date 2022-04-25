require 'minitest/autorun'
require_relative '../payment_record'

class TestPaymentRecord < Minitest::Test
  def test_initialize_with全角区切り
    record = PaymentRecord.parse(time_stamp: "1649767760.123", content_str: "おやつ　90")
    assert_equal(2022, record.date.year)
    assert_equal(record.goods, "おやつ")
    assert_equal(record.price, 90)
  end

  def test_init_with半角区切り
    record = PaymentRecord.parse(time_stamp: "1649767760", content_str: "定期代 43430")
    assert_equal(record.goods, "定期代")
    assert_equal(record.price, 43430)
  end

  def test_another_initializer
    record = PaymentRecord.new(date: DateTime.new(2020, 11, 1),
                              goods: "えびせん", price: 120)
    assert_equal(2020, record.date.year)
    assert_equal(120, record.price)
  end
end