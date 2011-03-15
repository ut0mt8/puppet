Facter.add(:raid_type) do
	setcode do
		raid_type = "none"
		modname = ""
		
		IO.foreach("/proc/modules") { |x|
			modname = "aacraid" if x =~ /^aacraid/
			modname = "meagaraid_sas" if x =~ /^megaraid_sas/
			modname = "megaraid_mm" if x =~ /^megaraid_mm/ 
			modname = "mptsas" if x =~ /^mptsas/ 
	        }
		
		if FileTest.exist?("/dev/aac0") and modname == "aacraid"
			raid_type = "aacraid"
		elsif FileTest.exist?("/dev/megadev0") and modname == "megaraid_sas"
			raid_type = "megaraid"
		elsif FileTest.exist?("/dev/mptctl") and modname == "mptsas"
			raid_type = "mpt"
		elsif FileTest.exist?("/proc/mdstat")
			IO.foreach("/proc/mdstat") { |y|
				raid_type = "swraid" if y =~ /md[0-9]+ : active/
			}
		end
		raid_type
	end
end
