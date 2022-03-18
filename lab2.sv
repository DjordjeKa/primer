
typedef enum{READ ,WRITE} direction;

typedef enum{FIXED,INCREMENT} burst_i;

class Configuration;
bit[1:0] address;
direction dir;
bit[15:0] data;

function new(bit[1:0] address,bit[15:0] data,direction dir);
 	this.address=address;
 	this.data=data;
 	this.dir=dir;
endfunction:new

endclass:Configuration





class Packet;
	int length;
	bit[31:0] start_adress;
	burst_i burst;
	bit[31:0] q1[$];

function new(int l,bit[31:0] s, burst_i b);
	this.length= l;
	this.start_adress=s;
	this.burst=b;
	for(int i=0;i<l;i++)
	begin
		if (burst==1)
		begin
		q1[i]=start_adress+i;
		end
		else
		q1[0]=start_adress+i;
	end
endfunction:new

function void print();
	for (int i=0;i<this.q1.size();i++)
	begin
		$display("%h", this.q1[i]);
	end
	$display("start adress %h , length %h , burst_i %d", this.start_adress, this.length, this.burst);
endfunction:print
endclass:Packet




class Memory;

bit [32:0] mem [512];

bit parity;
bit correct; 
reg [15:0] ENABLE;
reg [15:0]THRESHOLD_ADDRESS;
reg [15:0]THRESHOLD_LENGTH;
reg [15:0] RESET;



function void write(Packet p);
if(ENABLE!=0)
begin
	for(int i=p.start_adress;i<p.length+p.start_adress;i++)
	begin
		mem[i]=p.q1[i-p.start_adress];
		parity=parity^mem[i];
		mem[32]=parity; 
	end
end
if(THRESHOLD_ADDRESS!=0)
begin
	for(int i=p.start_adress;i<THRESHOLD_ADDRESS;i++)
  	begin
   		mem[i]=p.q1[i-p.start_adress];
   		parity=parity^mem[i];
   		mem[32]=parity; 
  	end
end
if(THRESHOLD_LENGTH!=0)
begin
	for(int i=p.start_adress;i<THRESHOLD_LENGTH+p.start_adress;i++)
	begin
   		mem[i]=p.q1[i-p.start_adress];
   		parity=parity^mem[i];
   		mem[32]=parity; 
 	end
end
if(RESET!=0)
begin
 	for(int i=p.start_adress;i<p.length+p.start_adress;i++)
  	begin
   		mem[i]=0;
   		parity=parity^mem[i];
   		mem[32]=parity; 
  	end
end
endfunction:write


function corrupt(bit[31:0] memory_location_index,int memory_bit_position_index);

	mem[memory_location_index][memory_bit_position_index]=~mem[memory_location_index][memory_bit_position_index];
	correct=parity^mem[memory_location_index][memory_bit_position_index];

endfunction:corrupt
 


function void read(bit[31:0] start_address,int read_length );
for (int i=start_address;i<read_length;i++) 
begin
   	$display(" address %h value %b", i,mem[i]);
end

if(correct==0)
begin
	$display("data bit is not corrupted ");
end
else
begin
    $display("data bit is corrupted");
end
endfunction:read


function void configure(Configuration conf);
 
if(conf.dir==1)
begin
	if(conf.address=='b00)
	begin
        	ENABLE=conf.data;
	end
	else if(conf.address=='b01)
	begin
		THRESHOLD_ADDRESS=conf.data;
	end
	else if(conf.address=='b10)
	begin
		THRESHOLD_LENGTH=conf.data;
	end
	else if(conf.address=='b11)
	begin
		RESET=conf.data;
	end
end
else
begin
	$display("Register ENABLE %b,Register THRESHOLD_ADDRESS %b ,Register THRESHOLD_LENGTH %b, Register RESET %b",ENABLE,THRESHOLD_ADDRESS,THRESHOLD_LENGTH,RESET);
end 
endfunction:configure

endclass:Memory

module lab2;
initial begin

bit[31:0] start_addr;
int length; 
burst_i burst;
Packet p;
Configuration conf;
Memory mem;
bit [31:0] memory_location_index;
int memory_bit_position_index;
bit [31:0] memory_location_index1;
int memory_bit_position_index1;

mem=new();
conf=new('b01,'b0000000100011001,WRITE);
p=new(45, 'h100, INCREMENT);


memory_location_index=$urandom_range(0,512);
memory_bit_position_index=$urandom_range(0,31);
memory_location_index1=$urandom_range(0,512);
memory_bit_position_index1=$urandom_range(0,31);
 

mem.configure(conf);
mem.write(p);
mem.corrupt(memory_location_index,memory_bit_position_index);
mem.corrupt(memory_location_index1,memory_bit_position_index1);
 
conf=new('b00,'b0000000000000001,READ);
mem.configure(conf);
mem.read(0,512);


end
 
endmodule

//xrun lab2.sv -timescale 1ns/1ns -sysv -access +rw -uvm -seed 1 -uvmhome CDNS-1.2 -covoverwrite -coverage all

