# Đổi prompt của irb
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT_MODE] = false
# Load Rails console nếu đang trong môi trường Rails
if defined?(Rails)
  Rails.application.console do |console|
    console.config.console
  end
end

# In ra một thông báo chào mừng
puts "Chào mừng đến với IRB!"
