
class frame;
	rand bit [7:0] payload;
	bit  parity;


	function void calculate_parity();
		parity=^payload[7:0];
	endfunction:calculate_parity

	function corrupt();
		parity=~parity;
	endfunction:corrupt

	function writep();
  		$display("%b",parity);
	endfunction:writep

	function bit check_parity();
	
		if(^payload[7:0]==parity)
 		begin
	
 			return 0;	
 		end
		else
  		begin  
	
  			return 1;
  		end
	endfunction:check_parity

endclass:frame


class start_frame extends frame;

 	constraint cons{payload=='hFF; } 
 
endclass:start_frame

class end_frame extends frame;

 	constraint cons1{payload=='hFE; }

endclass:end_frame
   
class high_payload_frames extends frame;

	constraint cons2{payload dist{['h0:'hEF]:=9,['hF0:'hFF]:=91}; }
	
endclass:high_payload_frames



class base_packet;

	frame frame_p;
	frame frames_q[$];
	rand bit[4:0] queue_lenth;

	task populate();

		for(int i=0;i<queue_lenth;i++)
	 	begin
		frame_p = new();
		frame_p.randomize();
		frame_p.calculate_parity();
	 	frames_q[i]=frame_p;
 	end

	endtask

	function print();
		for(int i=0;i<queue_lenth;i++) 
	 	begin
	 		$display(" position %d, %b ,%b",i,frames_q[i].payload,frames_q[i].parity);
	 	end
	endfunction:print

	virtual function replace_frame(frame frame_r,int num);
		if(num>=0&&num<queue_lenth)
		begin
			for(int i=0;i<queue_lenth;i++)
			begin
		
				if(num==i)
		  		begin
		  		frames_q[i]=frame_r;
		 	
				end
			end
		end
		else
		begin
			$display("there is no frame with position %d in one queue",num);
		end
	endfunction:replace_frame

	function check_frame_corruption();
	bit check;

		for(int i=0;i<queue_lenth;i++)
		begin
			 check=frames_q[i].check_parity();
			if(check==0)
			begin
				$display("%d Parity is OK on position %d",check,i);
			end
			else
			begin
				$display("%d Corrupted parity on position %d",check,i);
			end
		end
       		      
	endfunction:check_frame_corruption


endclass:base_packet



class uart extends base_packet ;

	frame frame_p;
	start_frame startt;
	end_frame en;

	constraint cons_ql{queue_lenth == 8;}

	task populate();

		startt=new();
		startt.randomize();
		en=new();
		en.randomize();
		startt.calculate_parity();
		frames_q[0]=startt;
	
		for(int i=1;i<queue_lenth-1;i++)
	 	begin    
			frame_p = new();
			frame_p.randomize();
	 	 	
			frame_p.calculate_parity();
			frames_q[i]=frame_p;
			 
	 	end
		en.calculate_parity(); 
		frames_q[7]=en;
		   
	endtask

	virtual function replace_frame(frame frame_r,int num);

		if(num>0&&num<7)
		begin
			for(int i=0;i<queue_lenth;i++)
			begin
		
				if(num==i)
		  		begin
		  			frames_q[i]=frame_r;
		 	
				end
			end
		end
		else
		begin
		$display("it is imposibile to replace frame nuber 1 and number 8");
		end

	
	endfunction:replace_frame


endclass:uart



module lab3;
initial begin

 	uart uart_t0,uart_t1,uart_t2,uart_t3,uart_t4,uart_t5;
 	base_packet packet_q[$]; 
 	base_packet bp0,bp1,bp2,bp3,bp4;
 
 	high_payload_frames hpf0,hpf1,hpf2,hpf3,hpf4,hpf5,hpf6,hpf7,hpf8,hpf9,hpf10,hpf11,hpf12,hpf13,hpf14;

	hpf0=new();
	hpf1=new();
	hpf2=new();
	hpf3=new();
	hpf4=new();
	hpf5=new();
	hpf6=new();
	hpf7=new();
	hpf8=new();
	hpf9=new();
	hpf10=new();
	hpf11=new();
	hpf12=new();
	hpf13=new();
	hpf14=new();

	hpf0.randomize();
	hpf1.randomize();
	hpf2.randomize();
	hpf3.randomize();
	hpf4.randomize();
	hpf5.randomize();
	hpf6.randomize();
	hpf7.randomize();
	hpf8.randomize();
	hpf9.randomize();
	hpf10.randomize();
	hpf11.randomize();
	hpf12.randomize();
	hpf13.randomize();
	hpf14.randomize();

	hpf0.calculate_parity();
	hpf1.calculate_parity();
	hpf2.calculate_parity();
	hpf3.calculate_parity();
	hpf4.calculate_parity();
	hpf5.calculate_parity();
	hpf6.calculate_parity();
	hpf7.calculate_parity();
	hpf8.calculate_parity();
	hpf9.calculate_parity();
 	hpf10.calculate_parity();
	hpf11.calculate_parity();
	hpf12.calculate_parity();
	hpf13.calculate_parity();
	hpf14.calculate_parity();

 	bp0=new();
 	bp1=new();
 	bp2=new();
 	bp3=new();
 	bp4=new();

 	bp0.randomize();
 	bp0.populate();
 
 	bp1.randomize();
 	bp1.populate();

 	bp2.randomize();
 	bp2.populate();

 	bp3.randomize();
 	bp3.populate();

 	bp4.randomize();
 	bp4.populate();

 	uart_t0=new(); 
 	uart_t1=new(); 
 	uart_t2=new(); 
 	uart_t3=new(); 
 	uart_t4=new(); 
 	uart_t5=new(); 
 
 	uart_t0.randomize();
 	uart_t0.populate();
 
 	uart_t1.randomize();
 	uart_t1.populate();

 	uart_t2.randomize();
 	uart_t2.populate();

 	uart_t3.randomize();
 	uart_t3.populate();

 	uart_t4.randomize();
 	uart_t4.populate();

 	uart_t5.randomize();
 	uart_t5.populate();

	
	
 	packet_q={bp0,bp1,bp2,bp3,bp4,uart_t0,uart_t1,uart_t2,uart_t3,uart_t4,uart_t5};
 	
	for(int i=0;i<packet_q.size();i++)
	begin
  		packet_q[i].print();
		$display("---------------------");
	end

	
        hpf0.corrupt();
	hpf1.corrupt();
	hpf2.corrupt();
	hpf3.corrupt();
	hpf4.corrupt();
	hpf5.corrupt();
	hpf6.corrupt();
	hpf7.corrupt();
	hpf8.corrupt();
	hpf9.corrupt();
	hpf10.corrupt();
	hpf11.corrupt();
	hpf12.corrupt();
	hpf13.corrupt();
	hpf14.corrupt();
	

	packet_q[0].replace_frame(hpf9,1);
 	packet_q[1].replace_frame(hpf1,0);
	packet_q[2].replace_frame(hpf0,0);
	packet_q[3].replace_frame(hpf3,1);
	packet_q[4].replace_frame(hpf12,5);
	packet_q[5].replace_frame(hpf7,1);
	packet_q[7].replace_frame(hpf6,1);
	packet_q[7].replace_frame(hpf14,2);
	packet_q[7].replace_frame(hpf12,1);
	packet_q[8].replace_frame(hpf11,7);
	
	$display("+++++++++++++++++ after replacing");
	for(int i=0;i<packet_q.size();i++)
	begin
  		packet_q[i].print();
		$display("after replacing ");
		packet_q[i].check_frame_corruption();
		
	end
end
endmodule:lab3



//xrun lab3.sv -timescale 1ns/1ns -sysv -access +rw -uvm -seed 1 -uvmhome CDNS-1.2 -covoverwrite -coverage all
