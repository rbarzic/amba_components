//****************************************************************************/
//  AHB Components
//  RTL IMPLEMENTATION, Synchronous Version
//
//  Copyright (C) yyyy  Ronan Barzic - rbarzic@gmail.com
//  Date            :  Mon Nov  9 11:05:41 2015
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
//  Filename        :  ahb_params.v
//
//  Description     :  AHB related parameters
//
//
//
//****************************************************************************/


// AMBA 3 AHB-Lite Protocol - 3.2 Transfer type
localparam AMBA_AHB_HTRANS_IDLE    = 2'b00;
localparam AMBA_AHB_HTRANS_BUSY    = 2'b01;
localparam AMBA_AHB_HTRANS_NON_SEQ = 2'b10;
localparam AMBA_AHB_HTRANS_SEQ     = 2'b11;

localparam AMBA_AHB_HSIZE_8BITS      = 3'b000;
localparam AMBA_AHB_HSIZE_16BITS     = 3'b001;
localparam AMBA_AHB_HSIZE_32ITS      = 3'b010;
localparam AMBA_AHB_HSIZE_64ITS      = 3'b011;
localparam AMBA_AHB_HSIZE_128BITS    = 3'b100;
localparam AMBA_AHB_HSIZE_256BITS    = 3'b101;
localparam AMBA_AHB_HSIZE_512BITS    = 3'b110;
localparam AMBA_AHB_HSIZE_1024BITS   = 3'b111;
