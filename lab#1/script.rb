#!/usr/bin/env ruby -W0

require 'tlsmail'
require 'time'

# Username and Password of Ruby Script Notifier
$email_user = 'ruby.script.notifier@gmail.com'
$email_pass = 'password12345#'

# Send notification emails to
$to_email   = 'roman.roibu@gmail.com'

def show_help
  puts "USEFULL INFORMATION GOES HERE." #TODO
end

if ARGV[0]
  case ARGV[0]
  when '-h', '--help', 'help'
    show_help
    exit
  when ->(x){Dir.exists?(x)}
    Dir.chdir(ARGV[0])
  else
    puts "Error: Script argument error: \"#{ARGV[0]}\""
    exit
  end
end

def git_commit(options)
  command = 'git commit '
  command << '--quiet ' unless options[:quiet] == false
  command << '--allow-empty ' if options[:allow_empty]
  command << "-m \"#{options[:message]}\" " if options[:message]
  command << "--all " if options[:all]
  command << options[:files].join(' ') if options[:files]
  system( command )
end

def git_checkout(options)
  command = 'git checkout '
  command << '--quiet ' unless options[:quiet] == false
  command << '--verbose ' if options[:verbose]
  command << '-b ' if options[:create]
  command << options[:branch]
  system( command )
end

def git_merge(options)
  command = 'git merge '
  command << '--quiet ' unless options[:quiet] == false
  command << '--verbose ' if options[:verbose]
  command << "-m \"#{options[:message]}\" " if options[:message]
  command << options[:branch]
  system( command )
end

def send_email(failed)
  from = $email_user
  pass = $email_pass
  to   = $to_email

  content =  "From: \"Ruby Script\"\n"
  content << "To: #{to}\n"
  content << "Subject: \"Warning: Compilation Issues\"\n"
  content << "Date: #{Time.new.rfc2822}\n\n"
  content << "While compiling the \"HelloWorldPrograms\", the following files failed to compile:\n\n"
  failed.each_with_index { |file,i| content << (i+1).to_s + '. file: ' + file[:name] + ' from: ' + file[:path] + "\n"}
  content << "\nPlease find the problem and resolve the issues.\n"

  Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
  response = Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', from, pass, :login) do |smtp|
    smtp.send_message(content, from, to)
  end
  # Positive Completion reply, if response code is of the form 2xx
  response[0].to_i == 2
end

lang_info = {
  "c"      => {extension: "*.c",    compiler: "gcc "},
  "cpp"    => {extension: "*.cpp",  compiler: "g++ "},
  "java"   => {extension: "*.java", compiler: "javac ", interpreter: "java "},
  "ruby"   => {extension: "*.rb",   interpreter: "ruby "},
  "python" => {extension: "*.py",   interpreter: "python "}
}

print "===== RUBY SCRIPT BEGIN =====\n\n"

puts "Checkout into \"compilation-test\" branch"
git_checkout branch: "compilation-test", create: true

# initialize array for failed files
# each element should be a hash:
# :name --- filename
# :path --- file path
failed_compilations = []

dirs = Dir["*/"].map do |d| /(?<d1>(.)*)([\/])/ =~ d; d1 end

dirs.each do |lang|
  Dir.chdir(lang)
  puts "\nProcessing #{lang.capitalize} files in #{Dir.pwd}"

  # get files according to filename extensions
  files = Dir.glob( lang_info[lang][:extension] )

  case lang
  when "c"
    # C stuff
    files.each do |file|
      /(?<filename>(\w+|[-]*)*)(\.(w+))*/ =~ file
      command = lang_info[lang][:compiler]
      command += file + " -o compiled-c-" + filename
      if system( command )
        msg = "Successful compilation of #{file}"
        puts msg
        if git_commit allow_empty: true, message: msg
          puts "Successful commit"
        else
          puts "Failed commit"
        end
        puts "\n===PROGRAM OUTPUT==="
        system( "./compiled-c-" + filename )
      else
        puts "Failed compilation of #{file}"
        failed_compilations << {name: file, path: Dir.pwd}
      end
    end

  when "cpp"
    # C++ stuff
    files.each do |file|
      /(?<filename>(\w+|[-]*)*)(\.(w+))*/ =~ file
      command = lang_info[lang][:compiler]
      command += file + " -o compiled-cpp-" + filename
      if system( command )
        msg = "Successful compilation of #{file}"
        puts msg
        if git_commit allow_empty: true, message: msg
          puts "Successful commit"
        else
          puts "Failed commit"
        end
        puts "\n===PROGRAM OUTPUT==="
        system( "./compiled-cpp-" + filename )
      else
        puts "Failed compilation of #{file}"
        failed_compilations << {name: file, path: Dir.pwd}
      end
    end

  when "java"
    # Java stuff
    files.each do |file|
      /(?<filename>(\w+|[-]*)*)(\.(w+))*/ =~ file
      command = lang_info[lang][:compiler] + file
      old_files = Dir['*']
      if system( command )
        msg = "Successful compilation of #{file}"
        puts msg
        if git_commit allow_empty: true, message: msg
          puts "Successful commit"
        else
          puts "Failed commit"
        end
        new_files = Dir['*'] - old_files
        new_files.each do |file|
          puts "\n===PROGRAM #{file} OUTPUT==="
          /(?<filename>(\w+|[-]*)*)(\.(w+))*/ =~ file
          system( "java " + filename )
        end
      else
        puts "Failed compilation of #{file}"
        failed_compilations << {name: file, path: Dir.pwd}
      end
    end

  when "ruby"
    # Ruby stuff
    files.each do |file|
      /(?<filename>(\w+|[-]*)*)(\.(w+))*/ =~ file
      command = lang_info[lang][:interpreter] + file
      puts "\n===PROGRAM OUTPUT==="
      success = system( command )
      print "\n"
      if success
        msg = "Successful running of #{file}"
        puts msg
        if git_commit allow_empty: true, message: msg
          puts "Successful commit"
        else
          puts "Failed commit"
        end
      else
        puts "Failed running of #{file}"
        failed_compilation << {name: file, path: Dir.pwd}
      end
    end

  when "python"
    # Python stuff
    files.each do |file|
      /(?<filename>(\w+|[-]*)*)(\.(w+))*/ =~ file
      command = lang_info[lang][:interpreter] + file
      puts "\n===PROGRAM OUTPUT==="
      success = system( command )
      print "\n"
      if success
        msg = "Successful running of #{file}"
        puts msg
        if git_commit allow_empty: true, message: msg
          puts "Successful commit"
        else
          puts "Failed commit"
        end
      else
        puts "Failed running of #{file}"
        failed_compilations << {name: file, path: Dir.pwd}
      end
    end

  else
    puts "Warning: Don't know how to process files of this language."
  end

  # go back to parent dir ("HelloWorldPrograms")
  Dir.chdir("..")
end

unless failed_compilations.empty?
  puts "\nSending email with failed info"
  send_email(failed_compilations) ? puts("Successful email") : puts("Failed email")
end

puts "\nCheckout to previous branch, and merge:"
puts "Successful checkout" if git_checkout branch: '-' # checkout to previus branch
puts "Successful merge" if git_merge branch: 'compilation-test', message: "Merge compilation-test branch"

puts "\n===== RUBY  SCRIPT  END ====="

