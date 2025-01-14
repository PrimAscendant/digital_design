/*same moments as in mux.sv (IO names + data types)
Also better use input parameters for such approach
"input logic [FA_BIT_WIDTH -1:0] a,b;" INSTEAD OF "input wire [3:0] a, b;"
It gives more flexability for your design
*/

module one_bit_full_addr(
  input wire a, b,
  input wire cin,
  output wire sum,
  output wire cout);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (cin & (a^b));
endmodule 

module four_bit_full_adder(
  input wire [3:0] a, b,
  input wire cin,
  output wire [3:0] sum,
  output wire cout);
  
  wire c1,c2,c3;
  
  //Better to use generate construction for wide bit adders. For 4 bits its still ok 
  /*
  genvar i;
  generate
    for(i=0; i < BIT_WIDTH; i++)begin : ADDER
    if(i == 0)
      one_bit_full_addr fa(a[i],b[i],cin,sum[i],cout[i]);
    else if(i == BIT_WIDTH -1 )
      one_bit_full_addr fa(a[i],b[i],cout[i-1],sum[i],cout);
    else
      one_bit_full_addr fa(a[i],b[i],cout[i-1],sum[i],cout[i]);
    end
  endgenerate
  */
  one_bit_full_addr fa0(a[0],b[0],cin,sum[0],c1);
  one_bit_full_addr fa1(a[1],b[1],c1,sum[1],c2);
  one_bit_full_addr fa2(a[2],b[2],c2,sum[2],c3);
  one_bit_full_addr fa3(a[3],b[3],c3,sum[3],cout);

endmodule
