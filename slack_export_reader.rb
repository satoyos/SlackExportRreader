require 'pp'
require 'json'
require_relative 'payment_record'

class SlackExportReader
  attr_reader :files, :jsons

  def initialize(folder_path:)
    raise "フォルダ[#{folder_path}]は見つかりません]" unless Dir.exist? folder_path
    @folder_path = folder_path
    @files = []
    @jsons = []
    Dir.open(folder_path) do |dir|
      for item in dir
        @files.append item if item =~ /.json$/
      end
    end

  end

  def load_json_from_files
    raise "JSONデータを読み込むファイルがありません" if files.empty?
    for file in files
      File.open(File.join(@folder_path, file)) do |f|
        json_data = JSON.load(f, nil, {symbolize_names: true, create_additions: false})
        # json_data = JSON.load(f)
        @jsons.append(json_data)
      end
    end
    return self
  end

  def extract_payment_records(first_name: nil, from: nil, to: DateTime.now())
    first_name = ENV['SPENDER'] if first_name.nil?
    raise("first_name must be given to extra_payment_recored, as an argument or Environtment Variable 'SPENDER") if first_name.nil?
    results = []
    for json in jsons
      for item in json
        next unless item[:type] == "message"
        next if item[:subtype]
        next unless item[:user_profile][:first_name] == first_name
        results.append(
          PaymentRecord.parse(
            time_stamp: item[:ts],
            content_str: item[:text]
          )
        )
      end
    end
    from = Time.at(0).to_datetime if from.nil?
    results = results.select{|rec| rec.date >= from and rec.date <= to}
    return results.sort{|x, y| x.date <=> y.date}
  end
end

if __FILE__ == $0
  if ARGV.length != 1
    puts "usage: ruby #{__FILE__} folder_path_name"
  end

  def stdout_record_in_csv_formst(recs)
    total_price = 0
    puts '入力日,品目,価格'
    for rec in recs
      date_str = rec.date.strftime("%Y/%m/%d")
      puts "#{date_str},#{rec.goods},#{rec.price}"
      total_price += rec.price
    end
    puts ",合計,#{total_price}"
  end

  reader = SlackExportReader.new(folder_path: ARGV[0])
  records = reader.load_json_from_files
                  .extract_payment_records()
  # pp records
  stdout_record_in_csv_formst(records)
end