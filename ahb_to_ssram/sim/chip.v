//****************************************************************************/
//  AMBA Components
//  RTL IMPLEMENTATION, Synchronous Version
//
//  Copyright (C) yyyy  Ronan Barzic - rbarzic@gmail.com
//  Date            :  Tue Nov 10 20:52:02 2015
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,MA 02110-1301,USA.
//
//
//  Filename        :  chip.v
//
//  Description     :  main file for simulation or synthesis trial
// (ahb_to_ssram + memory blocks)
//
//
//
//****************************************************************************/


module chip (/*AUTOARG*/
   // Outputs
   HRDATA, HREADYOUT, HRESP,
   // Inputs
   HADDR, HCLK, HREADY, HRESETn, HSEL, HSIZE, HTRANS, HWDATA, HWRITE
   );

   parameter AW = 12;



   input [AW-1:0]       HADDR;                  // To U_AHB_TO_SSRAM of ahb_to_ssram.v
   input                HCLK;                   // To U_AHB_TO_SSRAM of ahb_to_ssram.v, ...
   input                HREADY;                 // To U_AHB_TO_SSRAM of ahb_to_ssram.v
   input                HRESETn;                // To U_AHB_TO_SSRAM of ahb_to_ssram.v
   input                HSEL;                   // To U_AHB_TO_SSRAM of ahb_to_ssram.v
   input [2:0]          HSIZE;                  // To U_AHB_TO_SSRAM of ahb_to_ssram.v
   input [1:0]          HTRANS;                 // To U_AHB_TO_SSRAM of ahb_to_ssram.v
   input [31:0]         HWDATA;                 // To U_AHB_TO_SSRAM of ahb_to_ssram.v
   input                HWRITE;                 // To U_AHB_TO_SSRAM of ahb_to_ssram.v

   output [31:0]        HRDATA;                 // From U_AHB_TO_SSRAM of ahb_to_ssram.v
   output               HREADYOUT;              // From U_AHB_TO_SSRAM of ahb_to_ssram.v
   output               HRESP;                  // From U_AHB_TO_SSRAM of ahb_to_ssram.v
   // End of automatics

   /*AUTOINPUT*/
   /*AUTOOUTPUT*/


   /*AUTOREG*/
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [AW-1:0]        ahb_sram_addr;          // From U_AHB_TO_SSRAM of ahb_to_ssram.v
   wire [31:0]          ahb_sram_din;           // From U_AHB_TO_SSRAM of ahb_to_ssram.v
   wire [3:0]           ahb_sram_enb;           // From U_AHB_TO_SSRAM of ahb_to_ssram.v
   wire [3:0]           ahb_sram_wb;            // From U_AHB_TO_SSRAM of ahb_to_ssram.v
   wire [31:0]          sram_ahb_dout;          // From U_RAM0 of sync_ram_wf.v, ...
   // End of automatics


   ahb_to_ssram  #(.AW(AW)) U_AHB_TO_SSRAM
  (
   .ahb_sram_we                         (),
   .ahb_sram_en                         (),







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
   .HCLK                                (HCLK),
   .HRESETn                             (HRESETn),
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
      .clk(HCLK),

     ); */
   sync_ram_wf #(.WORD_WIDTH(8),.ADDR_WIDTH(AW-2))
   U_RAM0 (
                           /*AUTOINST*/
           // Outputs
           .dout                        (sram_ahb_dout[7:0]),    // Templated
           // Inputs
           .clk                         (HCLK),                  // Templated
           .we                          (ahb_sram_wb[0]),        // Templated
           .en                          (ahb_sram_enb[0]),       // Templated
           .addr                        (ahb_sram_addr[9:0]),    // Templated
           .din                         (ahb_sram_din[7:0]));     // Templated


   sync_ram_wf #(.WORD_WIDTH(8),.ADDR_WIDTH(AW-2))
   U_RAM1 (/*AUTOINST*/
           // Outputs
           .dout                        (sram_ahb_dout[15:8]),   // Templated
           // Inputs
           .clk                         (HCLK),                  // Templated
           .we                          (ahb_sram_wb[1]),        // Templated
           .en                          (ahb_sram_enb[1]),       // Templated
           .addr                        (ahb_sram_addr[9:0]),    // Templated
           .din                         (ahb_sram_din[15:8]));    // Templated

   sync_ram_wf #(.WORD_WIDTH(8),.ADDR_WIDTH(AW-2))
   U_RAM2 (/*AUTOINST*/
           // Outputs
           .dout                        (sram_ahb_dout[23:16]),  // Templated
           // Inputs
           .clk                         (HCLK),                  // Templated
           .we                          (ahb_sram_wb[2]),        // Templated
           .en                          (ahb_sram_enb[2]),       // Templated
           .addr                        (ahb_sram_addr[9:0]),    // Templated
           .din                         (ahb_sram_din[23:16]));   // Templated

   sync_ram_wf #(.WORD_WIDTH(8),.ADDR_WIDTH(AW-2))
   U_RAM3 (/*AUTOINST*/
           // Outputs
           .dout                        (sram_ahb_dout[31:24]),  // Templated
           // Inputs
           .clk                         (HCLK),                  // Templated
           .we                          (ahb_sram_wb[3]),        // Templated
           .en                          (ahb_sram_enb[3]),       // Templated
           .addr                        (ahb_sram_addr[9:0]),    // Templated
           .din                         (ahb_sram_din[31:24]));   // Templated







endmodule // chip
/*
 Local Variables:
 verilog-library-directories:(
 "."
 )
 End:
 */
