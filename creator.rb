arg = ARGV[0]
file = File.open(arg)

case File.extname(file)
when '.png', '.jpg', '.gif' then
  puts 'Input charactor name: '
  char_name = STDIN.gets.chomp

  BASE_DIR = Dir.home + "/.atom/packages/atom-pronama-chan/assets"

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
else
  puts 'Invalid input file.'
end
