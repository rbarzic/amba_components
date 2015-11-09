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
   wire [31:0]          HRDATA;                 // From U_CHIP of ahb_to_ssram.v
   wire                 HREADY;                 // From U_AHB_DRIVER of ahb_driver.v
   wire                 HREADYOUT;              // From U_CHIP of ahb_to_ssram.v
   wire                 HRESP;                  // From U_CHIP of ahb_to_ssram.v
   wire                 HSEL;                   // From U_AHB_DRIVER of ahb_driver.v
   wire [2:0]           HSIZE;                  // From U_AHB_DRIVER of ahb_driver.v
   wire [1:0]           HTRANS;                 // From U_AHB_DRIVER of ahb_driver.v
   wire [31:0]          HWDATA;                 // From U_AHB_DRIVER of ahb_driver.v
   wire                 HWRITE;                 // From U_AHB_DRIVER of ahb_driver.v
   wire [AW-1:0]        ahb_sram_addr;          // From U_CHIP of ahb_to_ssram.v
   wire [31:0]          ahb_sram_din;           // From U_CHIP of ahb_to_ssram.v
   wire [3:0]           ahb_sram_enb;           // From U_CHIP of ahb_to_ssram.v
   wire [3:0]           ahb_sram_wb;            // From U_CHIP of ahb_to_ssram.v
   wire [31:0]          sram_ahb_dout;          // From U_RAM0 of sync_ram_wf.v, ...
   // End of automatics



  ahb_to_ssram  #(.AW(AW)) U_CHIP // We override the MAX_VALUE default value
  (
   .ahb_sram_we                         (),
   .ahb_sram_en                         (),


   .HCLK                                (clk),
   .HRESETn                             (rst_n),



   /*AUTOINST*/
   // Outputs
   .HREADYOUT                           (HREADYOUT),
   .HRDATA                              (HRDATA[31:0]),
   .HRESP                               (HRESP),
   .ahb_sram_addr                       (ahb_sram_addr[AW-1:0]),
   .ahb_sram_enb                        (ahb_sram_enb[3:0]),
   .ahb_sram_wb                         (ahb_sram_wb[3:0]),
   .ahb_sram_din                        (ahb_sram_din[31:0]),
   // Inputs
   .rst_n                               (rst_n),
   .clk                                 (clk),
   .HSEL                                (HSEL),
   .HADDR                               (HADDR[AW-1:0]),
   .HTRANS                              (HTRANS[1:0]),
   .HSIZE                               (HSIZE[2:0]),
   .HWRITE                              (HWRITE),
   .HWDATA                              (HWDATA[31:0]),
   .HREADY                              (HREADY),
   .sram_ahb_dout                       (sram_ahb_dout[31:0]));

     /* sync_ram_wf AUTO_TEMPLATE(
      .dout            (sram_ahb_dout[@"(+ 7 (* 8 @))":@"(* 8 @)"]),
      .din            (ahb_sram_din[@"(+ 7 (* 8 @))":@"(* 8 @)"]),
      .we              (ahb_sram_wb[@]),
      .en              (ahb_sram_enb[@]),
      .addr            (ahb_sram_addr[9:0]),

     ); */
   sync_ram_wf #(.WORD_WIDTH(8),.ADDR_WIDTH(AW))
   U_RAM0 (
                           /*AUTOINST*/
           // Outputs
           .dout                        (sram_ahb_dout[7:0]),    // Templated
           // Inputs
           .clk                         (clk),
           .we                          (ahb_sram_wb[0]),        // Templated
           .en                          (ahb_sram_enb[0]),       // Templated
           .addr                        (ahb_sram_addr[9:0]),    // Templated
           .din                         (ahb_sram_din[7:0]));     // Templated


   sync_ram_wf #(.WORD_WIDTH(8),.ADDR_WIDTH(AW))
   U_RAM1 (/*AUTOINST*/
           // Outputs
           .dout                        (sram_ahb_dout[15:8]),   // Templated
           // Inputs
           .clk                         (clk),
           .we                          (ahb_sram_wb[1]),        // Templated
           .en                          (ahb_sram_enb[1]),       // Templated
           .addr                        (ahb_sram_addr[9:0]),    // Templated
           .din                         (ahb_sram_din[15:8]));    // Templated

   sync_ram_wf #(.WORD_WIDTH(8),.ADDR_WIDTH(AW))
   U_RAM2 (/*AUTOINST*/
           // Outputs
           .dout                        (sram_ahb_dout[23:16]),  // Templated
           // Inputs
           .clk                         (clk),
           .we                          (ahb_sram_wb[2]),        // Templated
           .en                          (ahb_sram_enb[2]),       // Templated
           .addr                        (ahb_sram_addr[9:0]),    // Templated
           .din                         (ahb_sram_din[23:16]));   // Templated

   sync_ram_wf #(.WORD_WIDTH(8),.ADDR_WIDTH(AW))
   U_RAM3 (/*AUTOINST*/
           // Outputs
           .dout                        (sram_ahb_dout[31:24]),  // Templated
           // Inputs
           .clk                         (clk),
           .we                          (ahb_sram_wb[3]),        // Templated
           .en                          (ahb_sram_enb[3]),       // Templated
           .addr                        (ahb_sram_addr[9:0]),    // Templated
           .din                         (ahb_sram_din[31:24]));   // Templated





    /* ahb_driver  AUTO_TEMPLATE(
     ); */
   ahb_driver  #(.AW(AW)) U_AHB_DRIVER (
                             .HCLK              (clk),
                             .HRESETn           (rst_n),
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
                               .rst_n           (rst_n),
                               // Inputs
                               .clk             (clk),
                               .rst_async       (rst_async));





  // Dump all nets to a vcd file called tb.vcd
  initial
     begin
	$dumpfile("tb.vcd");
	$dumpvars(0,tb);
     end

  // Start by pulsing the reset low for some nanoseconds
  reg [31:0] tmp;

  initial begin
    rst_async = 1'b0;



    #100;
    rst_async = 1'b1;
    @(posedge clk);
    @(posedge clk);
     #3;

     U_AHB_DRIVER.t_write32bits_non_seq(12'h010,32'hCAFEBABE);
     @(posedge clk);
     U_AHB_DRIVER.t_write32bits_non_seq(12'h014,32'h12345678);
     @(posedge clk);
     @(posedge clk);
     U_AHB_DRIVER.t_read32bits_non_seq(12'h010,tmp);
     #1000;

    $display("-I- Done !");
    $finish;
  end

   // watchdog
   initial begin
      #10000;
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
