module div_4(
    input clk,
    input rst_n,
    output reg clk_out
);
reg [1:0]cnt;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt<=0;
    else begin
        if (cnt==3)
            cnt<=0;
        else
            cnt<=cnt+1;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        clk_out<=0;
    end
    else begin
        if(cnt==3)
            clk_out<=~clk_out;
        else
            clk_out<=clk_out;
    end
end
endmodule