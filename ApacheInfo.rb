
x = `dir C:\\ /s /b | find \"conf\\httpd.conf\"`

$apache_loc = x.split(/\n/)

if $apache_loc.length > 1
	puts "Which ones you wanna scan?"
	for i in 0...$apache_loc.length
		num = (i+1).to_s
		$apache_loc[i] = File.expand_path("../..", $apache_loc[i])
		puts num << '. ' << $apache_loc[i]
	end

	choice = gets.to_i - 1
	while choice >= $apache_loc.length || choice < 0
		puts "No such choice, please try again"
		choice = gets.to_i - 1
	end
	$apache_loc = $apache_loc[choice]
else
	$apache_loc = $apache_loc[0]
end

#set $apache_config_loc
$apache_config_loc = File.expand_path("./conf/httpd.conf", $apache_loc)

#set version
apache_bin_loc = File.expand_path("./bin",$apache_loc)
begin
	$apache_version = `#{apache_bin_loc}/httpd -v`
	#puts 'httpd -v'
rescue
	$apache_version = `#{apache_bin_loc}/apache -v`
	#puts 'apache -v'
end
/.*(\d.\d.\d).*/ =~ $apache_version
$apache_version = $1.to_i



