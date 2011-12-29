require "open3"

watch('src/(.*)\.haml') do |md|
  stdin, stdout, stderr = Open3.popen3("haml #{md[0]}")

  error_message = ''
  unless stderr.eof?
    error_message << stderr.to_a.join
  end

  unless error_message.empty?
    system "growlnotify", "-t", md[0], "-m", error_message
    next
  end

  File.open("./dist/#{md[1]}.html", 'w') do |html|
    html << stdout.to_a.join
  end
  system "growlnotify", "-t", md[0], "-m", "Compiled successfully."
end
