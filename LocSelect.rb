
x = `dir C:\\ /s /b | find \"conf\\httpd.conf\"`

#x = "C:\\xampp\\apache\\conf\n"
#x = "C:\\xampp\\apache\\conf\nC:\\User"

$configLoc = x.split(/\n/)

if $configLoc.length > 1
	$stderr.puts "Which config you wanna scan?"
	for i in 0...$configLoc.length
		num = (i+1).to_s
		$stderr.puts num << '. ' << $configLoc[i]
	end
	choice = gets.to_i - 1
	$configLoc = $configLoc[choice]
else
	$configLoc = $configLoc[0]
end

$configLoc = File.expand_path("./", $configLoc)
$apacheLoc = File.expand_path("../..", $configLoc)

#puts $configLoc, $apacheLoc