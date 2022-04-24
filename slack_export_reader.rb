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
  end

  def extract_payment_records()
    results = []
    for json in jsons
      for item in json
        next unless item[:type] == "message"
        next if item[:subtype]
        next unless item[:user_profile][:first_name] == "John"
        results.append(
          PaymentRecord.new(
            date_str: "2030/3/22",
            content_str: item[:text]
          )
        )
      end
    end

    return results
  end
end