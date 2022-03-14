
typedef enum{FIXED,INCREMENT} burst_i;

class Packet;
int length;
bit[31:0] start_adress;
burst_i burst;
bit[31:0] q1[$];

function new(int len,bit[31:0] start_a, burst_i burst);
  this.length= len;
  this.start_adress=start_a;
  this.burst=burst;
  for(int i=0;i<length;i++)
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
bit [31:0] mem [512];

function void write(Packet p);
for(int i=p.start_adress;i<p.length+p.start_adress;i++)
 begin
 mem[i]=p.q1[i-p.start_adress];
 end
endfunction:write

function void read(bit[31:0] start_adress,int read_length );
 for (int i=start_adress;i<read_length;i++) 
 begin
 $display(" adress %h value %h", i,mem[i]);
 end
endfunction:read
endclass:Memory


module lab1;
initial begin

 
 Packet p;
 Memory mem;
 p=new(45, 'h100, FIXED);
 mem=new();
 
 //p=new(20,'h200,INCREMENT);
 p.print();
 mem.write(p);
 mem.read(0,512);

end
endmodule
