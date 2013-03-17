require_relative 'LocSelect'

#file = open('./data/test.txt')
file = open($configLoc)
$stderr.puts "Scanning..."

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

while line = file.gets

	
	next if  /^\s+#/ =~ line # To Ignore commend ,equal to /^#/x:
	next if in_directory?(line)	# in or out directory
	if /^\s*$/ =~ line # 空白行
		puts line
		next
	end


	line.chomp!
	lineKey , lineVal = line.split(/ /)

	if lineKey == 'DocumentRoot' #將DocumentRoot存入$docRoot
		$docRoot = lineVal 
		#$stderr.puts $docRoot
	end

	if config.has_key?(lineKey) #若line為欲測之設定
		config.each{ |key,value|
			#value[1] is flag
			if (lineKey.downcase == key.downcase)
				if(lineVal.downcase == value[0].downcase)
					$stderr.puts 'OK'
					puts line
					value[1] = 1
				else
					line = key + ' ' + value[0]
					$stderr.puts "Set: "+ line
					puts line
					value[1] = 1
				end
				break
			end
			#print 'hi'
		}

	else
		puts line
	end
end

config.each{ |key,value|
	if value[1] == 0
		line = key + ' ' + value[0]
		puts line
		$stderr.puts "Set: "+ line
	end
}

puts "RewriteCond %{HTTP:range} !(^bytes=[^,]+(,[^,]+){0,4}$|^$)"
puts "RewriteRule .* - [F]"

file.close

#'<directory"c:/programfiles/apachegroup/apache2/htdocs\">\n'
#'<directory"c:/xampp/htdocs">'
#dir c:\\ /s /b | find \"conf\\httpd.conf\"

# method1	/^abcde$/i =~ "abCDe"
	
# method2
#	x = "abcde"
#	z = Regexp.new(x<<'$',true) #z=>/abcde$/i
