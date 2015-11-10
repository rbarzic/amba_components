`timescale 1ns/1ps
module tb;
`include "useful_tasks.v"  // some helper tasks

   // `include "ahb_driver.v"
   reg rst_async; // asynchronous reset
   wire rst_n; // synchronous reset (falling edge)
   wire done_r;
   wire clk;

   parameter AW = 12;

   /*AUTOINPUT*/
   /*AUTOOUTPUT*/
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [AW-1:0]        HADDR;                  // From U_AHB_DRIVER of ahb_driver.v
   wire [31:0]          HRDATA;                 // From U_CHIP of chip.v
   wire                 HREADY;                 // From U_AHB_DRIVER of ahb_driver.v
   wire                 HREADYOUT;              // From U_CHIP of chip.v
   wire                 HRESP;                  // From U_CHIP of chip.v
   wire                 HSEL;                   // From U_AHB_DRIVER of ahb_driver.v
   wire [2:0]           HSIZE;                  // From U_AHB_DRIVER of ahb_driver.v
   wire [1:0]           HTRANS;                 // From U_AHB_DRIVER of ahb_driver.v
   wire [31:0]          HWDATA;                 // From U_AHB_DRIVER of ahb_driver.v
   wire                 HWRITE;                 // From U_AHB_DRIVER of ahb_driver.v
   // End of automatics


   /* chip  AUTO_TEMPLATE(
    .HRESETn                             (rst_n),
    ); */
   chip   #(.AW(AW)) U_CHIP
     (
      .HCLK                                (clk),
      /*AUTOINST*/
      // Outputs
      .HRDATA                           (HRDATA[31:0]),
      .HREADYOUT                        (HREADYOUT),
      .HRESP                            (HRESP),
      // Inputs
      .HADDR                            (HADDR[AW-1:0]),
      .HREADY                           (HREADY),
      .HRESETn                          (rst_n),                 // Templated
      .HSEL                             (HSEL),
      .HSIZE                            (HSIZE[2:0]),
      .HTRANS                           (HTRANS[1:0]),
      .HWDATA                           (HWDATA[31:0]),
      .HWRITE                           (HWRITE));


   /* ahb_driver  AUTO_TEMPLATE(
    .HRESETn           (rst_n),
    ); */
   ahb_driver  #(.AW(AW)) U_AHB_DRIVER (
                                        .HCLK              (clk),

                                        /*AUTOINST*/
                                        // Outputs
                                        .HSEL           (HSEL),
                                        .HADDR          (HADDR[AW-1:0]),
                                        .HTRANS         (HTRANS[1:0]),
                                        .HSIZE          (HSIZE[2:0]),
                                        .HWRITE         (HWRITE),
                                        .HWDATA         (HWDATA[31:0]),
                                        .HREADY         (HREADY),
                                        // Inputs
                                        .HRESETn        (rst_n),         // Templated
                                        .HREADYOUT      (HREADYOUT),
                                        .HRDATA         (HRDATA[31:0]),
                                        .HRESP          (HRESP));




   clock_gen U_CLK_GEN (
                        /*AUTOINST*/
                        // Outputs
                        .clk            (clk));


   /* reset_generator AUTO_TEMPLATE(
    ); */
   reset_generator U_RESET_GEN (
                                /*AUTOINST*/
                                // Outputs
                                .rst_n          (rst_n),
                                // Inputs
                                .clk            (clk),
                                .rst_async      (rst_async));





   // Dump all nets to a vcd file called tb.vcd
   initial
     begin
	$dumpfile("tb.vcd");
	$dumpvars(0,tb);
     end

   // Start by pulsing the reset low for some nanoseconds
   reg [31:0] tmp;
   reg [7:0]  tmp8;

   initial begin
      rst_async = 1'b0;



      #100;
      rst_async = 1'b1;
      @(posedge clk);
      @(posedge clk);
      #3;

      U_AHB_DRIVER.t_write32bits_non_seq(12'h010,32'hCAFEBABE);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_write32bits_non_seq(12'h014,32'h12345678);
      @(posedge clk);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_read32bits_non_seq(12'h010,tmp);
      check_32bits(tmp,32'hCAFEBABE);

      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_read32bits_non_seq(12'h014,tmp);
      check_32bits(tmp,32'h12345678);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_write8bits_non_seq(12'h010,8'h55);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_read32bits_non_seq(12'h010,tmp);
      check_32bits(tmp,32'hCAFEBA55);
      @(posedge clk);

      #3;
      U_AHB_DRIVER.t_write8bits_non_seq(12'h011,8'hAA);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_write8bits_non_seq(12'h012,8'hBB);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_write8bits_non_seq(12'h013,8'hCC);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_read32bits_non_seq(12'h010,tmp);
      check_32bits(tmp,32'hCCBBAA55);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_read8bits_non_seq(12'h010,tmp8);
      check_8bits(tmp8,8'h55);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_read8bits_non_seq(12'h011,tmp8);
      check_8bits(tmp8,8'hAA);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_read8bits_non_seq(12'h012,tmp8);
      check_8bits(tmp8,8'hBB);
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_read8bits_non_seq(12'h013,tmp8);
      check_8bits(tmp8,8'hCC);

      // Read immediatly followed by a write (Pipelining)
      @(posedge clk);
      #3;
      U_AHB_DRIVER.t_read_then_write_32bits(12'h010,tmp,12'h014,32'hDEADBEEF);
      check_32bits(tmp,32'hCCBBAA55);
      U_AHB_DRIVER.t_read32bits_non_seq(12'h014,tmp);
      check_32bits(tmp,32'h12345678);
      @(posedge clk);


      #1000;

      $display("-I- Done !");
      $finish;
   end

   // watchdog
   initial begin
      #100000;
      $display("-E- Error (watchdog) !");
      $finish;
   end

endmodule // tb
/*
 Local Variables:
 verilog-library-directories:(
 "."
 )
 End:
 */
