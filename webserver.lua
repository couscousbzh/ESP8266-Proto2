
sendFileContents = function(conn, filename)      
	if file.open(filename, "r") then
		--conn:send(responseHeader("200 OK","text/html"));          
		repeat           
			local line=file.readline()           
			if line then               
				conn:send(line);          
			end           
		until not line           
		file.close();      
	else
		conn:send(responseHeader("404 Not Found","text/html"));          
		conn:send("Page not found");              
    end  
end 

responseHeader = function(code, type)      
    return "HTTP/1.1 " .. code .. "\r\nConnection: close\r\nServer: nunu-Luaweb\r\nContent-Type: " .. 
    type .. "\r\n\r\n";   
end 

httpserver = function ()      
    start_init();   
    srv=net.createServer(net.TCP)       
    srv:listen(80,function(conn)         
		conn:on("receive",function(conn,request)           
			print(request);
			
			conn:send(responseHeader("200 OK","text/html"));          
			
			if string.find(request,"gpio=0") then              
				print("gpio=0");
				if D0_state==0 then
				   D0_state=1;gpio.write(0,gpio.LOW);              
				else                  
				   D0_state=0;gpio.write(0,gpio.HIGH);              
				end          
			elseif string.find(request,"gpio=1") then              
				print("gpio=1");
				if D1_state==0 then                  
				   D1_state=1;gpio.write(4,gpio.LOW);              
				else  
				   D1_state=0;gpio.write(4,gpio.HIGH);
				end          
			else              
				if D0_state==0 then                  
					preset0_on="";              
				end              
				if D0_state==1 then                  
					preset0_on="checked=\"checked\"";              
				end              
				if D1_state==0 then                  
					preset1_on="";              
				end              
				if D1_state==1 then                  
					preset1_on="checked=\"checked\"";              
				end 

				sendFileContents(conn,"header.htm");
				conn:send("<div><input type=\"checkbox\" id=\"checkbox0\" name=\"checkbox0\" class=\"switch\" onclick=\"loadXMLDoc(0)\" "..preset0_on.." />");
				conn:send("<label for=\"checkbox0\">D0</label></div>");              
				conn:send("<div><input type=\"checkbox\" id=\"checkbox1\" name=\"checkbox1\"  class=\"switch\" onclick=\"loadXMLDoc(1)\" "..preset1_on.." />");   
				conn:send("<label for=\"checkbox1\">D1</label></div>");              
				conn:send("</div></body></html>");   
			end        
			print("Response sent to client");
		end)         
        conn:on("sent",function(conn)           
			conn:close();           
			conn = nil;              
		end)      
    end)  
end    
