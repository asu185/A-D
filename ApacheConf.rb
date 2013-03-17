puts "Please wait..."
require_relative 'ApacheInfo'


input = open($apache_config_loc,"r")
output = open("new.conf","w")

puts "Scanning..."

config = {
	"ServerSignature" => ["Off",0], # 0: This config not exist
	"ServerTokens" => ["Prod",0],
	"RewriteEngine" => ["On",0]
	#"LimitRequestBody" => ["1048576",0]
}

$dir_flag = 0 # 0: not within directory
$docRoot = ''

def in_directory?(line)	#是否在目標目錄內
	dir = "<Directory " << $docRoot	#若line為目錄頭
	if Regexp.new(dir,true) =~ line
		$dir_flag = 1
		return false
	elsif /^<\/directory>/i =~ line #若line為目錄尾
		$dir_flag = 0
		return false
	elsif $dir_flag == 1
		return true
	else
		return false
	end
end

while line = input.gets

	
	next if  /^\s+#/ =~ line # To Ignore commend ,equal to /^#/x:
	next if in_directory?(line)	# in or out directory
	if /^\s*$/ =~ line # 空白行
		output.puts line
		next
	end


	line.chomp!
	lineKey , lineVal = line.split(/ /)

	if lineKey == 'DocumentRoot' #將DocumentRoot存入$docRoot
		$docRoot = lineVal 
		#puts $docRoot
	end

	if config.has_key?(lineKey) #若line為欲測之設定
		config.each{ |key,value|
			#value[1] is flag
			if (lineKey.downcase == key.downcase)
				if(lineVal.downcase == value[0].downcase)
					puts 'OK'
					output.puts line
					value[1] = 1
				else
					line = key + ' ' + value[0]
					puts "Set: "+ line
					output.puts line
					value[1] = 1
				end
				break
			end
			#print 'hi'
		}

	else
		output.puts line
	end
end

config.each{ |key,value|
	if value[1] == 0
		line = key + ' ' + value[0]
		output.puts line
		puts "Set: "+ line
	end
}

if $apache_version<=2.2
	output.puts "RewriteCond %{HTTP:range} !(^bytes=[^,]+(,[^,]+){0,4}$|^$)"
	output.puts "RewriteRule .* - [F]"
end

input.close
output.close

system "pause"
#'<directory"c:/programfiles/apachegroup/apache2/htdocs\">\n'
#'<directory"c:/xampp/htdocs">'
#dir c:\\ /s /b | find \"conf\\httpd.conf\"

# method1	/^abcde$/i =~ "abCDe"
	
# method2
#	x = "abcde"
#	z = Regexp.new(x<<'$',true) #z=>/abcde$/i
