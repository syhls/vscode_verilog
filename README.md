# 使用VScode进行Verilog波形仿真

### 一、VScode的设置

VScode需要安装以下的插件，这样vscode可以更方便的进行Verilog的编辑：

![插件1](E:\FPGA_study\github\vscode_verilog\image\插件1.png)

### 二、Iverilog环境的搭建

点击此链接进入gittee下载或者直接使用我上传的安装包进行安装：

```
https://gitee.com/sunzhenyu59/i-verilog-assistant
```

在安装时可以自动添加环境变量，推荐勾选，这样后期不用手动添加环境变量。

### 三、Verilog源代码以及TestBench编写

此处以偶数（四）分频器进行演示，源代码以及tb文件都有上传

源代码如下：

```verilog
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
```

接下来是TestBench的编写，与常规的tb文件有一点区别，加了两部分内容。（后面有完整代码）

加上去的第一部分是生成的波形文件的文件名以及tb的模块名

```verilog
initial begin//加上这个才能用vvp生成wave文件
    $dumpfile("wave.vcd");  //生成的wave文件名
    $dumpvars(0, div_4tb);	// tb的模块名
end
```

第二部分是仿真的运行时长，与Modelsim和Vivado在仿真里面设置时长不一样，这个要手动在tb文件里面设置

```verilog
initial #10000 $finish;//仿真的运行时长，这个也要加
```

完整代码如下：

```verilog
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
initial #10000 $finish;//仿真的运行时长，这个也要加
div_4 tb_div_4(
    .rst_n(rst_n),
    .clk(clk),
    .clk_out(clk_out)
);
endmodule
```

### 三、编译代码以及仿真

打开终端，cmd或者vscode的终端均可，输入如下指令：

```bat
iverilog -o "test_tb.vvp" tb.v div_4.v
```

如果代码有误会在终端报错，报错格式和quertus或者vivado类似，自行对代码进行debug。

如果正确运行会生成一个test_tb.vvp的文件，接着运行：

```bat
vvp test_tb.vvp
```

生成的wave.vcd即为最后的波形文件

### 四、波形文件查看

##### 方法1：

iverilog整合下载了GTKwave，使用方法是在终端输入如下指令：

```bat
gtkwave wave.vcd
```

打开窗口如图，点击div_tb->tb_div_4->依次选择下面的信号，点击下面的insert导入。导入后可以选择左上方的缩放等按键进行调整

<img src="E:\FPGA_study\github\vscode_verilog\image\gtkwave.png" alt="gtkwave"  />

##### 方法2：

安装vscode插件，如图：

![wavetrace](E:\FPGA_study\github\vscode_verilog\image\wavetrace.png)

使用方法就是使用vscode打开wave.vcd文件，窗口如下：

![yanshi2](E:\FPGA_study\github\vscode_verilog\image\yanshi2.png)

然后点击"Add Signals"，双击需要添加的信号即可

![yanshi3](E:\FPGA_study\github\vscode_verilog\image\yanshi3.png)

滑动滚轮是调节x轴缩放，y轴的缩放以及信号的颜色在此处调整

![yanshi4](E:\FPGA_study\github\vscode_verilog\image\yanshi4.png)

## 那么你已经学会使用vscode进行波形仿真了！~~妈妈再也不用担心我电脑存储空间不够没法安装vivado了~~

### 当然，这种方式应该仅适用于代码量较小的波形仿真，涉及多模块时可能会有问题。