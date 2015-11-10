//****************************************************************************/
//  AMBA conponents
//  RTL IMPLEMENTATION, Synchronous Version
//
//  Copyright (C) yyyy  Ronan Barzic - rbarzic@gmail.com
//  Date            :  Mon Nov  9 10:03:03 2015
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
//  Filename        :  sync_ram_wf.v
//
//  Description     :   Synchronous RAM model, write first
//                     suitable for FPGA synthesis (Xilinx Block RAM)
//                     Source : ug901-vivado-synthesis-examples.zip
//
//****************************************************************************/



module sync_ram_wf (/*AUTOARG*/
   // Outputs
   dout,
   // Inputs
   clk, we, en, addr, din
   );

   parameter WORD_WIDTH = 16;
   parameter ADDR_WIDTH = 10;


   input clk;
   input we;
   input en;
   input [9:0] addr;
   input [WORD_WIDTH-1:0] din;
   output [WORD_WIDTH-1:0] dout;
   reg [WORD_WIDTH-1:0]    RAM [(2<<ADDR_WIDTH)-1:0];
   reg [WORD_WIDTH-1:0]    dout;

   always @(posedge clk)
     begin
        if (en)
          begin
             if (we)
               begin
                  RAM[addr] <= din;
                  dout <= din;
               end
             else begin
               dout <= RAM[addr];

             end
          end
     end
endmodule // sync_ram_wf
/*
 Local Variables:
 verilog-library-directories:(
 "."
 )
 End:
 */
