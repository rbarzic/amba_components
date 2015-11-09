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
   reg           HWDATA;




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





endmodule // ahb_driver
/*
 Local Variables:
 verilog-library-directories:(
 "."
 )
 End:
 */
