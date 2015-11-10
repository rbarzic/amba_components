//****************************************************************************/
//  AMBA Components
//  RTL IMPLEMENTATION, Synchronous Version
//
//  Copyright (C) yyyy  Ronan Barzic - rbarzic@gmail.com
//  Date            :  Mon Nov  9 21:38:06 2015
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
//  Filename        :  ahb_driver.v
//
//  Description     :  Verification driver for AHB-Lite
//
//
//
//****************************************************************************/



module ahb_driver (/*AUTOARG*/
   // Outputs
   HSEL, HADDR, HTRANS, HSIZE, HWRITE, HWDATA, HREADY,
   // Inputs
   HCLK, HRESETn, HREADYOUT, HRDATA, HRESP
   );
   parameter AW = 12;

   input   HCLK;    // Clock
   input   HRESETn; // Reset
   output  HSEL;    // Device select
   output [AW-1:0] HADDR;   // Address
   output [1:0]    HTRANS;  // Transfer control
   output [2:0]    HSIZE;   // Transfer size
   output          HWRITE;  // Write control
   output [31:0]   HWDATA;  // Write data
   output          HREADY;  // Transfer phase done
   input           HREADYOUT; // Device ready
   input [31:0]    HRDATA;    // Read data output
   input           HRESP;     // Device response (always OKAY)


`include "ahb_params.v"

   /*AUTOINPUT*/
   /*AUTOOUTPUT*/

   /*AUTOREG*/
   /*AUTO*/
   reg  [AW-1:0] HADDR;   // Address
   reg           HWRITE;
   reg           HSIZE;
   reg           HTRANS;
   reg           HREADY;
   reg           HSEL;
   reg [31:0]    HWDATA;




   task t_read32bits_non_seq;
      input [AW-1:0] address;
      output [31:0]  data;

      begin
         HSEL   = 1'b1;
         HADDR = address;
         HWRITE = 1'b0;
         HTRANS = AMBA_AHB_HTRANS_NON_SEQ;
         HSIZE  = AMBA_AHB_HSIZE_32BITS;
         HREADY = 1'b1;

         @(posedge HCLK);
         #5;
         HWRITE = 1'b0;
         while(!HREADYOUT)
           @(posedge HCLK);
         data = HRDATA;
         HSEL = 1'b0;


      end
   endtask // read_non_seq

   task t_read8bits_non_seq;
      input [AW-1:0] address;
      output [7:0]  data;

      begin

         HSEL   = 1'b1;
         HADDR = address;
         HWRITE = 1'b0;
         HTRANS = AMBA_AHB_HTRANS_NON_SEQ;
         HSIZE  = AMBA_AHB_HSIZE_8BITS;
         HREADY = 1'b1;

         @(posedge HCLK);
         #5;
         HWRITE = 1'b0;
         while(!HREADYOUT)
           @(posedge HCLK);
         case(HADDR[1:0])
           0 : begin
              data = HRDATA[7:0];
           end
           1 : begin
              data = HRDATA[15:8];
           end
           2 : begin
              data = HRDATA[23:16];
           end
           3 : begin
              data = HRDATA[31:24];
           end
           default: begin
           end

         endcase

         HSEL = 1'b0;


      end
   endtask // read_non_seq

   task t_write32bits_non_seq;
      input [AW-1:0] address;
      input [31:0]   data;


      begin
         HSEL   = 1'b1;
         HADDR = address;
         HWRITE = 1'b1;
         HTRANS = AMBA_AHB_HTRANS_NON_SEQ;
         HSIZE  = AMBA_AHB_HSIZE_32BITS;
         HREADY = 1'b1;


         @(posedge HCLK);
         #5;

         HWDATA = data;


         HWRITE = 1'b0;
         while(!HREADYOUT)
           @(posedge HCLK);
         #5;
         HSEL = 1'b0;

      end
   endtask // read_non_seq

   task t_write8bits_non_seq;
      input [AW-1:0] address;
      input [7:0]   data;
      reg [31:0]    word_to_be_written;
      begin
         HSEL   = 1'b1;
         HADDR = address;
         HWRITE = 1'b1;
         HTRANS = AMBA_AHB_HTRANS_NON_SEQ;
         HSIZE  = AMBA_AHB_HSIZE_8BITS;
         HREADY = 1'b1;




         @(posedge HCLK);
         #5;
         // Fixme - HADDR could be changed by the next access
         case(HADDR[1:0])
           0 : begin
              word_to_be_written = {24'b0,data};
           end
           1 : begin
              word_to_be_written = {16'b0,data,8'b0};
           end
           2 : begin
              word_to_be_written = {8'b0,data,16'b0};
           end
           3 : begin
              word_to_be_written = {data,24'b0};
           end
           default: begin
           end

         endcase


         HWDATA = word_to_be_written;

         HWRITE = 1'b0;
         while(!HREADYOUT)
           @(posedge HCLK);
         #5;
         HSEL = 1'b0;

      end
   endtask // read_non_seq



   task t_read_then_write_32bits;
      input [AW-1:0] address1;
      output [31:0]  data1;
      input [AW-1:0] address2;
      input [31:0]  data2;

      begin
         HSEL   = 1'b1;
         HADDR = address1;
         HWRITE = 1'b0;
         HTRANS = AMBA_AHB_HTRANS_NON_SEQ;
         HSIZE  = AMBA_AHB_HSIZE_32BITS;
         HREADY = 1'b1;

         @(posedge HCLK);
         #5;
         HADDR = address2;
         HTRANS = AMBA_AHB_HTRANS_NON_SEQ;
         HSIZE  = AMBA_AHB_HSIZE_32BITS;
         HREADY = 1'b1;
         HWRITE = 1'b1;
         while(!HREADYOUT)
           @(posedge HCLK);
         data1 = HRDATA;
         HWDATA = data2;
         HWRITE = 1'b0;
         while(!HREADYOUT)
           @(posedge HCLK);
         #5;
         HSEL = 1'b0;


      end
   endtask // read_non_seq




endmodule // ahb_driver
/*
 Local Variables:
 verilog-library-directories:(
 "."
 )
 End:
 */
