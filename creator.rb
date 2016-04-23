# coding: utf-8
require 'singleton'

class InvalidImageError < StandardError
end

class InvalidInputError < StandardError
end

class AtomCharactorCreator
  include Singleton

  BASE_DIR = Dir.home + "/.atom/packages/atom-pronama-chan/assets"

  def input
    begin
      arg = ARGV[0]
      file = File.open(arg)

      raise InvalidImageError unless isValidImage?(file)
    rescue TypeError # 引数ミスの補足
      puts 'Usage: ruby creator.rb [image]'
    rescue Errno::ENOENT => e # ファイルが存在しない場合の補足
      puts "#{e}"
    rescue InvalidImageError # 対応しない画像形式が入力された時の補足
      puts 'Invalid Image file.'
      puts 'Valid type: *.png, *.jpg, *.gif'
    rescue
      puts 'A fatal error occured during file I/O'
    else
      setup(file)
    end
  end

  private
  def isValidImage?(file)
    case File.extname(file)
    when '.png', '.jpg', '.gif'
      true
    else
      false
    end
  end

  def setup(file)
    begin
    puts 'Input charactor name: '
    char_name = STDIN.gets.chomp

    raise InvalidInputError if char_name == nil
    rescue
      puts 'Invalid Input.'
    else
      if Dir.exist?("#{BASE_DIR}/#{char_name}") then
        puts "#{char_name} is already exists."
      else
        `mkdir #{BASE_DIR}/#{char_name}`
        `mkdir #{BASE_DIR}/#{char_name}/image/`
        `cp #{File.absolute_path(file)} #{BASE_DIR}/#{char_name}/image/`
        `mkdir #{BASE_DIR}/#{char_name}/voice/`
        `touch #{BASE_DIR}/#{char_name}/config.json`

        config_file = File.open("#{BASE_DIR}/#{char_name}/config.json", "w")

        config_file.print("""{
    \"images\": {
      \"background\": \"#{File.basename(file)}\"
    },
    \"startVoice\": {},
    \"timeSignal\": []
  }""")
      end
    end
  end
end

class Main
  include Singleton
  AtomCharactorCreator.instance.input
end
