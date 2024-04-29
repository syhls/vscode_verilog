`timescale 1ns/1ns
module div_4tb();
reg rst_n;
reg clk;
wire clk_out;
initial begin//加上这个才能用vvp生成wave文件
    $dumpfile("wave.vcd");  //生成的wave文件名
    $dumpvars(0, div_4tb);	// tb的模块名
end

initial begin
    rst_n=1;
    clk=0;
    #5
    rst_n=0;
    #20
    rst_n=1;
end
always begin
    #5
    clk=~clk;
end
initial #10000 $finish;//仿真的运行时长
div_4 tb_div_4(
    .rst_n(rst_n),
    .clk(clk),
    .clk_out(clk_out)
);
endmodule