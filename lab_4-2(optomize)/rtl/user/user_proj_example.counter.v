// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32,
    parameter DELAYS=0
)(
`ifdef USE_POWER_PINS
    inout                       vccd1,	// User area 1 1.8V supply
    inout                       vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input                       wb_clk_i,
    input                       wb_rst_i,
    input                       wbs_stb_i,
    input                       wbs_cyc_i,
    input                       wbs_we_i,
    input [3:0]                 wbs_sel_i,
    input [31:0]                wbs_dat_i,
    input [31:0]                wbs_adr_i,
    output                      wbs_ack_o,
    output[31:0]                wbs_dat_o,

    // Logic Analyzer Signals
    input [127:0]               la_data_in,
    output[127:0]               la_data_out,
    input [127:0]               la_oenb,

    // IOs
    input [`MPRJ_IO_PADS-1:0]   io_in,
    output[`MPRJ_IO_PADS-1:0]   io_out,
    output[`MPRJ_IO_PADS-1:0]   io_oeb,

    // IRQ
    output[2:0]                 irq
);


//==================================================================================//
//                      Memory map of user project                                  //
//==================================================================================//
//--------------- Upper address of wb bus -----------------//
    localparam Fir_base           = 16'h3000;
    localparam Bram_base          = 16'h3800;
//--------------- Lower address of wb bus -----------------//
    localparam pADDR_REF          = 8;
    localparam state_base         = 8'h00;
    localparam Data_len_base      = 8'h10;
    localparam Tap_num_base       = 8'h14;
    localparam Din_base           = 8'h40;
    localparam Dout_base          = 8'h44;
    localparam Tap_base           = 8'h80; 
//==================================================================================//
//                          Command type from wb bus                                //
//==================================================================================//
//----------------------- Cmd to userproject ----------------------//
//  * command type to user project area. 
//  * control fir       : wb bus send cmd to fir engine.  
//  * instruction fetch : wb bus fetch instruction from Bram.
//  * none              : wb bus don't call user project.  
    localparam Fir_control       = 2'b00;
    localparam Instruction_fetch = 2'b01;
    localparam None              = 2'b10;
//---------------------------- Cmd to fir -------------------------//
    localparam config_read       = 3'b000;
    localparam config_write      = 3'b001;
    localparam data_write        = 3'b010;
    localparam data_read         = 3'b011;
    localparam none_cmd          = 3'b100;
//-----------------------------------------------------------------//
    localparam INVALID_VALUE     = 32'hffff_ffff;
    localparam pADDR_WIDTH       = 12;
    localparam pDATA_WIDTH       = 32;
//===============================================================================//
//                           User Interface                                      //
//===============================================================================//
    wire                                axis_rst_n;
    wire                                rst;
    reg [31:0]                          wbs_dat_o_r;
    reg [31:0]                          wbs_dat_o_r_nxt;
    reg                                 wbs_ack_o_r;
    reg                                 wbs_ack_o_r_nxt;
    reg [3:0]                           counter;
    wire[`MPRJ_IO_PADS-1:0]             io_in;
    wire[`MPRJ_IO_PADS-1:0]             io_out;
    wire[`MPRJ_IO_PADS-1:0]             io_oeb;
//==============================================================================//
//                        COMMAND from WB bus                                   //
//==============================================================================//
    reg [1:0]                           usr_cmd ;
    reg [2:0]                           fir_cmd ;
//==============================================================================//
//                       FIR <-> RAM  interface                                 //
//==============================================================================//
    wire[(pADDR_WIDTH -1) : 0]          DATA_RAM_A;
    wire[(pDATA_WIDTH -1) : 0]          DATA_RAM_DO;
    wire[(pDATA_WIDTH -1) : 0]          DATA_RAM_DI;
    wire[3:0]                           DATA_RAM_WE;
    wire                                DATA_RAM_EN;
    
    wire[(pADDR_WIDTH-1) : 0]           TAP_RAM_A ;      
    wire[(pDATA_WIDTH-1) : 0]           TAP_RAM_DI;
    wire[(pDATA_WIDTH-1) : 0]           TAP_RAM_DO;
    wire                                TAP_RAM_EN;
    wire[3 : 0]                         TAP_RAM_WE;
//=============================================================================//
//                       FIR AXI STREAM interface                              //
//=============================================================================//
//--------------- AXI STREAM (data input) ----------------//
    wire                                ss_tvalid_w; 
    wire[(pDATA_WIDTH-1) : 0]           ss_tdata_w; 
    wire                                ss_tlast_w;
    wire                                ss_tready_w;
//-------------- AXI STREAM (result output) -------------//
    wire                                sm_tready_w;
    wire                                sm_tvalid_w;
    wire[(pDATA_WIDTH-1) : 0]           sm_tdata_w;
    wire                                sm_tlast_w;
//-------------- AXI LITE (config write) ----------------//
    wire                                awvalid_w;
    wire                                awready_w;
    wire                                wready_w;
    wire                                wvalid_w;
    wire[(pADDR_WIDTH-1) : 0]           awaddr_w;
    wire[(pDATA_WIDTH-1) : 0]           wdata_w ;
//-------------- AXI LITE (config read) -----------------//
    wire[(pADDR_WIDTH-1) : 0]           araddr_w;
    reg                                 axi_read_sent;
    reg                                 axi_read_sent_nxt;
    wire                                arvalid_w;
    wire                                rvalid_w ;
    wire                                rready_w ;
    wire                                arready_w ;
    wire[(pDATA_WIDTH-1) : 0]           rdata_w;
//-------------------------------------------------------//
    wire[(pADDR_WIDTH-1) : 0]           zero;


//=============================================================================//
//                       Instruction RAM interface                             //
//=============================================================================//
    wire[(pDATA_WIDTH-1) : 0]           INS_RAM_DI;
    wire[(pDATA_WIDTH-1) : 0]           INS_RAM_DO;
    wire[31 : 0]                        INS_RAM_A;
    wire                                INS_RAM_EN;
    wire[3 : 0]                         INS_RAM_WE;
    wire                                INS_RAM_V_nxt;
    reg                                 INS_RAM_V ;
//////////////////////////////////////////////////////////////////////////////////////    
    assign zero       = {(pADDR_WIDTH){1'b0}};
    assign io_out     = wbs_dat_o_r;
    assign io_oeb     = ~wbs_ack_o_r;
    assign axis_rst_n = !wb_rst_i;
//////////////////////////////////////////////////////////////////////////////////////
//                            WISHBONE BUS CMD DECODE                               //
//////////////////////////////////////////////////////////////////////////////////////
    always @(*)begin
        if(wbs_cyc_i && wbs_stb_i)begin
            case(wbs_adr_i[31:16])
                Fir_base  : usr_cmd  =  Fir_control ;
                Bram_base : usr_cmd  =  Instruction_fetch ;
                default   : usr_cmd  =  None ;
            endcase
        end else begin
            usr_cmd  =  None ;
        end
    end

    always @(*)begin
        if(usr_cmd == Fir_control)begin
            if(wbs_adr_i[(pADDR_REF -1) : 0] >= Tap_base )begin
                    fir_cmd = (wbs_we_i)?   config_write : config_read;
            end else begin
                case(wbs_adr_i[(pADDR_REF -1) : 0])
                    state_base    :  fir_cmd  = (wbs_we_i)?   config_write : config_read;
                    Data_len_base :  fir_cmd  = (wbs_we_i)?   config_write : config_read;
                    Tap_num_base  :  fir_cmd  = (wbs_we_i)?   config_write : config_read;
                    Din_base      :  fir_cmd  = (wbs_we_i)?   data_write   : none_cmd   ;
                    Dout_base     :  fir_cmd  = (wbs_we_i)?   none_cmd     : data_read  ;
                    default       :  fir_cmd  = none_cmd;
                endcase
            end
        end else begin
            fir_cmd = none_cmd ;
        end
    end

//////////////////////////////////////////////////////////////////////////////////////
//                                AXI LITE Interface                                //
//////////////////////////////////////////////////////////////////////////////////////
//  * Generate arvalid and rready while wishbone bus send configuration read cmd    //
//  * ,and use rvalid as wishbone bus's  ack signal.                                //                                                                                                                                          //
//  * Use axi_read_sent reg to make sure that arvalid only do one time max          //
//  * handshake per wishbone bus command.                                           //
//                                                                                  //
//  (I)AXI LITE read                                                                //                                                                                  //
//  * clk           >   |     |     |     |     |      |     |                      //   
//  * wb_cyc        >____/-------------------------------------                     //   
//  * wb_stb        >____/-------------------------------------                     //
//  * wb_acl_o      >__________________________________________ *delay 10 cycle     //
//  * wb_ack_o_r    >___________________________________/------                     //
//  * fir_cmd       > x |         config_read                                       //
//  * arvalid       >____/-----\______________________________                      //
//  * arready       >----------\______________________________                      //
//  * axi_read_sent >__________/------------------------------                      //
//  * rvalid        >____________________________/------\_____                      //
//  * rready        >____/------------------------------\_____                      //
//                                                                                  //
//  (II)AXI LITE write                                                              //
//  * clk           >   |     |     |     |     |      |     |                      //   
//  * wb_cyc        >____/-------------------------------------                     //   
//  * wb_stb        >____/-------------------------------------                     //
//  * wb_acl_o      >__________________________________________ *delay 10 cycle     //
//  * wb_ack_o_r    >___________/------------------------------                     //
//  * fir_cmd       > x |         config_write                                      //
//  * awvalid       >____/-----\_______________________________                     //
//  * awready       >----------\_______________________________                     //
//  * wvalid        >____/-----\_______________________________                     //
//  * wready        >----------\_______________________________                     //
//                                                                                  //
//==================================================================================//


    assign awvalid_w   = (fir_cmd == config_write)?  1'b1 : 1'b0;
    assign wvalid_w    = (fir_cmd == config_write)?  1'b1 : 1'b0;
    assign awaddr_w    = { zero[(pADDR_WIDTH-9) :0] , wbs_adr_i[7 : 0]};
    assign wdata_w     = wbs_dat_i;


    assign araddr_w    = { zero[(pADDR_WIDTH-9) :0] , wbs_adr_i[7 : 0]};
    assign arvalid_w   = (fir_cmd == config_read)?  (!axi_read_sent) : 1'b0;
    assign rready_w    = (fir_cmd == config_read)?  1'b1 : 1'b0;
    
    always @(*)begin
        if( fir_cmd == config_read )begin    
            axi_read_sent_nxt = (axi_read_sent)? 1'b1 : (arvalid_w && arready_w); 
        end else begin
            axi_read_sent_nxt = 1'b0;
        end
    end

    always @(posedge wb_clk_i)begin
        if(wb_rst_i)begin
            axi_read_sent <= 1'b0;
        end else if(wbs_ack_o)begin
            axi_read_sent <= 1'b0;
        end else begin
            axi_read_sent <= axi_read_sent_nxt;
        end
    end
//////////////////////////////////////////////////////////////////////////////////////
//                              AXI STREAM Interface                                //
//////////////////////////////////////////////////////////////////////////////////////
//                                                                                  //
//  (I) fir result read                                                             //
//  * clk           >   |     |     |     |     |      |     |                      //   
//  * wb_cyc        >____/-------------------------------------                     //   
//  * wb_stb        >____/-------------------------------------                     //
//  * wb_ack_o      >_________________________________________  *delay 10 cycle     //
//  * wb_ack_o_r    >____________________________/-------------                     //
//  * fir_cmd       > x |           data_read                                       //
//  * sm_tready     >____/-----------------------\____________                      //
//  * sm_tvalid     >______________________/-----\____________                      //
//  * wb_dat_o_r    >             xx            |  fir_result                       //
//                                                                                  //
//  (II) fir data input                                                             //
//  * clk           >   |     |     |     |     |      |     |                      //   
//  * wb_cyc        >____/-------------------------------------                     //   
//  * wb_stb        >____/-------------------------------------                     //
//  * wb_ack_o      >__________________________________________ *delay 10 cycle     //
//  * wb_ack_o_r    >________________/-------------------------                     //
//  * fir_cmd       > x |           data_write                                      //
//  * ss_tvalid     >____/-----------\_________________________                     //
//  * ss_tready     >__________/-----\_________________________                     //
//                                                                                  //
//                                                                                  //
//==================================================================================//
    
    assign ss_tvalid_w = (fir_cmd == data_write)?  1'b1 : 1'b0;
    assign ss_tdata_w  =  wbs_dat_i ;
    assign ss_tlast_w  = 1'b0;
    assign sm_tready_w = (fir_cmd == data_read)?   1'b1 : 1'b0;

//////////////////////////////////////////////////////////////////////////////////////
//                          User => WishBone Bus                                   // 
/////////////////////////////////////////////////////////////////////////////////////    
    assign wbs_ack_o  = (usr_cmd == Instruction_fetch)?  ((counter == DELAYS)? wbs_ack_o_r : 1'b0) : wbs_ack_o_r_nxt;
    assign wbs_dat_o  = (usr_cmd == Instruction_fetch)?  wbs_dat_o_r : wbs_dat_o_r_nxt;

    always @(*) begin
        if(wbs_ack_o_r)begin
            wbs_dat_o_r_nxt = wbs_dat_o_r;
        end else if(usr_cmd == Fir_control)begin
            case(fir_cmd)
                data_read   :  wbs_dat_o_r_nxt = sm_tdata_w;
                config_read :  wbs_dat_o_r_nxt = rdata_w;
                default :      wbs_dat_o_r_nxt = INVALID_VALUE;
            endcase
        end else if (usr_cmd == Instruction_fetch)begin
            wbs_dat_o_r_nxt = (INS_RAM_V)? INS_RAM_DO : INVALID_VALUE; 
        end else begin
            wbs_dat_o_r_nxt =  INVALID_VALUE;
        end
    end

    
    always @(*)begin
        if(wbs_ack_o_r)begin
            wbs_ack_o_r_nxt = 1'b1;
        end else if(usr_cmd == Fir_control)begin
            case(fir_cmd)
                config_read   : wbs_ack_o_r_nxt = rvalid_w ;
                config_write  : wbs_ack_o_r_nxt = (awready_w && wready_w) ;
                data_write    : wbs_ack_o_r_nxt = ss_tready_w;
                data_read     : wbs_ack_o_r_nxt = sm_tvalid_w ;
                default       : wbs_ack_o_r_nxt = 1'b1;   
            endcase 
        end else if(usr_cmd == Instruction_fetch)begin
            wbs_ack_o_r_nxt = (INS_RAM_V)? 1'b1 : 1'b0;
        end else begin
            wbs_ack_o_r_nxt = 1'b0;
        end
    end

    always @(posedge wb_clk_i)begin
        if(wb_rst_i)begin
            counter <= 4'd0; 
        end else if(wbs_ack_o)begin
            counter <= 4'd0;
        end else if(wbs_ack_o_r)begin
            counter <= counter + 4'd1;
        end
    end
    
    always @(posedge wb_clk_i)begin
        if(wb_rst_i)begin
           wbs_ack_o_r <= 1'b0;
           wbs_dat_o_r <= 32'd0;
        end else if(wbs_ack_o)begin
            wbs_ack_o_r <= 1'b0;
            wbs_dat_o_r <= 32'd0;
        end else begin
            wbs_ack_o_r <= wbs_ack_o_r_nxt;
            wbs_dat_o_r <= wbs_dat_o_r_nxt ;
        end
    end
/////////////////////////////////////////////////////////////////////////////////////
//                           Instruction RAM interface                             // 
///////////////////////////////////////////////////////////////////////////////////// 
    assign INS_RAM_A     = { 20'd0 , wbs_adr_i[11 : 0]};
    assign INS_RAM_EN    = (usr_cmd == Instruction_fetch)?   (!wbs_ack_o_r) : 1'b0;
    assign INS_RAM_DI    = wbs_dat_i;
    assign INS_RAM_WE    = (usr_cmd == Instruction_fetch)?  {4{wbs_we_i}}  : 4'b0000;
    assign INS_RAM_V_nxt = (INS_RAM_V)?     INS_RAM_V : INS_RAM_EN;


    always @(posedge wb_clk_i)begin
        if(wb_rst_i)begin
            INS_RAM_V <= 1'b0;
        end else if(wbs_ack_o)begin
            INS_RAM_V <= 1'b0;
        end else begin
            INS_RAM_V <= INS_RAM_V_nxt;
        end
    end
/////////////////////////////////////////////////////////////////////////////////////
//                                  LATENCY COUNTER                                // 
///////////////////////////////////////////////////////////////////////////////////// 
    reg [31:0] latency_cnt;
    
    always @(posedge wb_clk_i) begin
        if(wb_rst_i)begin
            latency_cnt <= 32'd0;
        end else if(sm_tready_w)begin
            latency_cnt <= 32'd0;
        end else if(sm_tvalid_w)begin
            latency_cnt <= latency_cnt + 32'd1;
        end
    end


//============================================================================//
    
    bram user_bram (
        .CLK(wb_clk_i),
        .WE0(INS_RAM_WE),
        .EN0(INS_RAM_EN),
        .Di0(INS_RAM_DI),
        .Do0(INS_RAM_DO),
        .A0(INS_RAM_A)
    );
    
    fir user_fir (
        // * data RAM interface
        .data_WE    ( DATA_RAM_WE ),
        .data_EN    ( DATA_RAM_EN ),
        .data_Di    ( DATA_RAM_DI ),
        .data_A     ( DATA_RAM_A ),
        .data_Do    ( DATA_RAM_DO ),
        // * clk 、 reset
        .axis_clk   ( wb_clk_i ),
        .axis_rst_n ( axis_rst_n ),
        // * AXI LITE interface
        .awready    ( awready_w ),  //
        .wready     ( wready_w  ),  //
        .awvalid    ( awvalid_w ),  //
        .wvalid     ( wvalid_w ),   //
        .awaddr     ( awaddr_w ),   //
        .wdata      ( wdata_w ),    //
        .arready    ( arready_w ) , //
        .rready     ( rready_w ),   //
        .arvalid    ( arvalid_w) ,  //
        .araddr     ( araddr_w ),   //
        .rvalid     ( rvalid_w ),   //
        .rdata      ( rdata_w  ),   //
        // * AXI STREAM input
        .ss_tvalid   ( ss_tvalid_w ), 
        .ss_tdata    ( ss_tdata_w ),   
        .ss_tlast    ( ss_tlast_w ),
        .ss_tready   ( ss_tready_w ),
        // * AXI STREAM output 
        .sm_tready   ( sm_tready_w), 
        .sm_tvalid   ( sm_tvalid_w), 
        .sm_tdata    ( sm_tdata_w), 
        .sm_tlast    ( sm_tlast_w), 
        
        // bram for tap RAM
        .tap_WE     ( TAP_RAM_WE ),
        .tap_EN     ( TAP_RAM_EN ),
        .tap_Di     ( TAP_RAM_DI ),
        .tap_Do     ( TAP_RAM_DO ),
        .tap_A      ( TAP_RAM_A )
    );


    bram32 tap_ram (
        .clk   ( wb_clk_i ), 
        .we    ( TAP_RAM_WE[0] ), 
        .re    ( TAP_RAM_EN ), 
        .waddr ( TAP_RAM_A ), 
        .raddr ( TAP_RAM_A ), 
        .wdi   ( TAP_RAM_DI ), 
        .rdo   ( TAP_RAM_DO )
    );

    bram32 data_ram (
        .clk   ( wb_clk_i ), 
        .we    ( DATA_RAM_WE[0] ), 
        .re    ( DATA_RAM_EN ), 
        .waddr ( DATA_RAM_A ), 
        .raddr ( DATA_RAM_A ), 
        .wdi   ( DATA_RAM_DI ), 
        .rdo   ( DATA_RAM_DO )
    );

endmodule

// ----------------------------------------------------------------------------------------------------------------------
//
// MIT License
// ---
// Copyright © 2023 Company
// .... Content of the license
// -----------------------------------------------------------------------------------------------------------------------
// =======================================================================================================================
// Module Name : FIR
// Author : Hsuan Jung,Lo
// Create Date: 4/20/2025
// Features & Functions:
// .
// .
// =======================================================================================================================
// Revision History:
// Date         by      Version     Change Description
// 4/23/2025   Hsuan      0.1       fix synthesis problem(timing loop) 
// 
//
// -----------------------------------------------------------------------------------------------------------------------

//--------------------------------------- AXI-LITE INTERFACE ------------------------------------------------------------//
//* While fir idle , send write request if write buffer has valid-address and valid-data .                               //
//* if it won't write in this or next cycle we send read request (when read buff has valid-address).                     //
//* It only allow to write cmd while engine is idle.                                                                     //
//* While fir is running ,you only can read configuration reg .If you read tap paramemter it will return 'hffffffff.     //
//* Make sure read and write requests are seperate.(write priority)                                                      //
//      clk           >|  |  |  |  |  |  |  |                                                                            //
//      tap_write     >___/---\__/---\__________(write request)                                                          //
//      tap_read      >________________/---\____(read request)                                                           //
//      tap_read_done >___________________/---\_(read finish,need 1cycle to read)                                        //
//      tap_WE        >___/---\__/---\___________                                                                        //
//      tap_EN        >___/---\__/---\_/---\____                                                                         //
//-----------------------------------------------------------------------------------------------------------------------//

//--------------------------------------AXI-STREAM INTERFACE (Data Input)------------------------------------------------//
//* If data buffer's valid bit is low  , interface can sample next data(pull up ss_tready).                              //
//* After buffer's data write into DATA RAM , invalidate the buffer's valid bit. Buffer can sample next data input.      //
//* Use input pointer , output pointer , and whether data RAM is full to decide write timing(when data_buff's valid      //
//* bit is high.) There are two condition (data RAM is full or not).                                                     //
//                                                                                                                       //
//* Condition I(data ram not full) :                                                                                     //
//    < Use output pointer to decide write timing(write pointer == 0) >                                                  //
//      clk           > |   |   |   |   |   |   |   |   |                                                                //
//      ss_tvalid     > _____/---\___________/--------\___                                                               //
//      ss_tready     > ----------\______________/---\____                                                               //
//      data_buff_v   > _________/---------------\________  (data_buffer's valid bit)                                    //
//      data_write    >______________________/---\________  (write request)                                              //
//      x_in_pointer  > | 5 | 5 | 5 | 5 | 5 | 6 | 6 | 6 |   (data RAM input pointer)                                     //
//      x_out_pointer > | 4 | 3 | 2 | 1 | 0 | 6 | 5 | 4 |   (data RAM output pointer)                                    //
//      h_out_pointer > | 1 | 2 | 3 | 4 | 5 | 0 | 1 | 2 |   (tap RAM output pointer)                                     //
//                                                                                                                       //
//* Condition II(data ram full) :                                                                                        //
//    < Use difference of input/output pointer to decide write timing(difference == 1) >                                 //
//      clk           > |    |    |    |    |    |    |    |    |                                                        //
//      ss_tvalid     > ______/----\_______________/---------\___                                                        //
//      ss_tready     > -----------\___________________/----\____                                                        //
//      data_buff_v   > _________/---------------------\________    (data_buffer's valid bit)                            //
//      data_write    >___________________________/----\________    (write request)                                      //
//      x_in_pointer  > | 28 | 28 | 28 | 28 | 28 | 29 | 29 | 29 |   (data RAM input pointer)                             //
//      x_out_pointer > | 01 | 00 | 31 | 30 | 29 | 29 | 28 | 27 |   (data RAM output pointer)                            //
//      h_out_pointer > | 27 | 28 | 29 | 30 | 31 | 00 | 01 | 02 |   (tap RAM output pointer)                             //
//-----------------------------------------------------------------------------------------------------------------------//

//-------------------------------------------FIR ENGINE PIPLINE----------------------------------------------------------//
//* Sperate the process in 3-stage(read data ram 、 mul 、 accumulation)by  register (x_dat_reg、 h_dat_reg、             //
//  mul_reg、acc_reg 、 y_buff). And use ss_stall and sm_stall while engin meet hazzard cause by input latency and       //
//  output transfer latency. Stall pointer first and stall acc_clear 、pipline stage reg delay 1 cycle.                  //
//                                                                                                                       //
//  ___________      ___________     __________     __________      _________                                            //
//  |         |      |         |     |         |    |         |     |        |                                           //
//  | Memory  |  =>  | dat_reg |  => | mul_reg | => | acc_reg |  => | y_buff |  => output                                //
//  |_________|      |_________|     |_________|    |_________|     |________|                                           //
//                                                                                                                       //
//                                                                                                                       //
// Stall signal                                                                                                          //
//  (I) Output transfer latency :                                                                                        //
//    The y_buff(out put buffer) has valid data while next data process is finished (need to go into buff).This will     //  
//    cause structure hazzard,so we use sm_stall to stall the engine.                                                    //
//      clk          > |    |    |    |    |    |    |    |    |    |   |                                                //
//      sm_tvalid    >--------------------------------\____/-------------                                                //
//      sm_tready    >___________________________/----\__________________                                                //
//      sm_stall     >_______/------------------------\__________________ (sm_stall imm to pointer)                      //
//      sm_stall_1   >____________/------------------------\_____________ (sm_stall with 1 cycle delay to stage reg)     //   
//      acc_clear    >____________/------------------------------\_______ (clean acc_reg and push data into output buff) //
//                                                                                                                       //   
//  (II) Input latency :                                                                                                 //
//     While one data is processed  ,we should write data into data ram. But if there is no valid data in data ram,      //
//     will cause data hazzard ,so we use ss_stall to stall the engine.                                                  //                                                                                                   //
//      clk          > |    |    |    |    |    |    |    |    |    |   |                                                //
//      ss_tvalid    >______________________/-------\____________________                                                //
//      ss_tready    >---------------------------\____/------------------                                                //
//      data_buff_v  >___________________________/----\__________________                                                //
//      ss_stall     >_______/-------------------\_______________________ (ss_stall imm to pointer)                      //
//      ss_stall_1   >____________/-------------------\__________________ (ss_stall with 1 cycle delay to stage reg)     //   
//      data_write   >___________________________/----\__________________                                                //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//  Pipline engine (assume tap_num = 32 , data_len > 32) stall control                                                   //
//                                                                                                                       //
// (I)  ss_stall control:                                                                                                //
//                                                                                                                       //
//      clk           > |        |        |        |        |        |        |        |                                 //
//      ss_stall      > ___________________/-----------------\_________________________                                  //
//      x_in_pointer  > |   11   |   11   |            12            |   12   |   12   |   stall immediately             //
//      x_out_pointer > |   13   |   12   |            12            |   11   |   10   |   stall immediately             //
//      h_out_pointer > |   30   |   31   |            00            |   01   |   02   |   stall immediately             //
//      ss_stall_1    >_____________________________/-----------------\_________________                                 // 
//      x_dat_reg     > |  #x15  |  #x14  |  #x13  |           #x12           |  $x12  |   stall delay 1 cycle           //
//      h_dat_reg     > |  #h28  |  #h29  |  #h30  |           #h31           |  #h00  |   stall delay 1 cycle           //
//      mul_reg       > | mul_16 | mul_15 | mul_14 |          mul_13          | mul_12 |   stall delay 1 cycle           //
//      acc_reg       > | acc_17 | acc_16 | acc_15 |          acc_14          | acc_13 |   stall delay 1 cycle           //
//                                                                                                                       //
// (II) sm_stall control :                                                                                               //
//                                                                                                                       //
//      clk           > |        |        |        |        |        |        |        |                                 //
//      sm_stall      > __________/-----------------\___________________________________                                 //
//      x_in_pointer  > |   10   |   10   |   10   |   10   |   10   |   10   |   10   |   stall immediately             //
//      x_out_pointer > |   08   |            07            |   06   |   05   |   04   |   stall immediately             //
//      h_out_pointer > |   02   |            03            |   04   |   05   |   06   |   stall immediately             //
//      sm_stall_1    > ___________________/-----------------\__________________________                                 // 
//      x_dat_reg     > |  #x10  |  #x09  |          #x08            |  #x07  |  #x06  |   stall delay 1 cycle           //
//      h_dat_reg     > |  #h0   |  #h01  |          #h02            |  #h03  |  #h04  |   stall delay 1 cycle           //
//      mul_reg       > |  ----  | mul_10 |         mul_09           | mul_08 | mul_07 |   stall delay 1 cycle           //
//      acc_reg       > |  ----  |  ----  |         acc_10           | acc_09 | acc_08 |   stall delay 1 cycle           //
//      acc_clear     > ___________________/--------------------------\_________________   stall delay 1 cycle           //
//                                                                                                                       //
//-----------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------//

module fir 
#(  parameter pADDR_WIDTH     = 12,                    //  * width of aaddress
    parameter pDATA_WIDTH     = 32,                    //  * width of data transfer   
    parameter pCOUNTER_WIDTH  = 32                     //  * width of counter (count number of data processed)
)
(
    input   wire [(pDATA_WIDTH-1):0] tap_Do,

    // bram for data RAM
    output  wire [3:0]               data_WE,
    output  wire                     data_EN,
    output  wire [(pDATA_WIDTH-1):0] data_Di,
    output  wire [(pADDR_WIDTH-1):0] data_A,
    input   wire [(pDATA_WIDTH-1):0] data_Do,

    input   wire                     axis_clk,
    input   wire                     axis_rst_n,

    output  wire                     awready,
    output  wire                     wready,
    input   wire                     awvalid,
    input   wire [(pADDR_WIDTH-1):0] awaddr,
    input   wire                     wvalid,
    input   wire [(pDATA_WIDTH-1):0] wdata,
    output  wire                     arready,
    input   wire                     rready,
    input   wire                     arvalid,
    input   wire [(pADDR_WIDTH-1):0] araddr,
    output  wire                     rvalid,
    output  wire [(pDATA_WIDTH-1):0] rdata,  

    input   wire                     ss_tvalid, 
    input   wire [(pDATA_WIDTH-1):0] ss_tdata, 
    input   wire                     ss_tlast,
    output  wire                     ss_tready, 
    input   wire                     sm_tready, 
    output  wire                     sm_tvalid, 
    output  wire [(pDATA_WIDTH-1):0] sm_tdata, 
    output  wire                     sm_tlast, 
    
    // bram for tap RAM
    output  wire [3:0]               tap_WE,
    output  wire                     tap_EN,
    output  wire [(pDATA_WIDTH-1):0] tap_Di,
    output  wire [(pADDR_WIDTH-1):0] tap_A

);

//==========================================================================================================================================//
//----------------------------------------------------- SIZE set ---------------------------------------------------------------------------//
localparam pPOINTER_WIDTH  = 5 ;                    //  * width of RAM pointer (refer by RAM's size: pointer_width = log2(RAM's row_num)), need to be smaller than address width *
localparam pDATA_RAM_DEPTH = 32;                    //  * num of words can store in DATA_RAM 
localparam pRAM_ADDR_MAX   = pDATA_RAM_DEPTH -1 ;   //  * maximum of the top word's address of data RAM   
localparam INVALID_VALUE   = 32'hffffffff ;         //  * Invalid value return for non_idle read
//----------------------------------------------- base address of configuration reg --------------------------------------------------------//
//  * Memory Map of configuration reg 
localparam ap_base        = 8'h00 ;
localparam dat_len_base   = 8'h10 ;
localparam tap_num_base   = 8'h14 ;
localparam tap_para_base  = 8'h80 ;
localparam tap_ram_base   = 12'h80;
localparam pCONFIG_REF    = 8; 
//-------------------------------------------------------- FIR STATE -----------------------------------------------------------------------//
//  * BIT0 ([0]) of FIR state = configuration of ap_start 
//  * BIT1 ([1]) of FIR state = configuration of ap_done
//  * BIT2 ([2]) of FIR state = configuration of ap_idle
localparam IDLE           = 3'b100;                 
localparam DONE           = 3'b110;                 
localparam START          = 3'b101;                 
localparam RUN            = 3'b000;                 
                     
//============================================================================================================================================//

//----------------------- AXI-LITE interface-----------------------//
reg [(pADDR_WIDTH-1) : 0]               tap_addr_wbuff ;
reg [(pADDR_WIDTH-1) : 0]               tap_addr_wbuff_nxt ;
reg [(pDATA_WIDTH-1) : 0]               tap_data_wbuff ;
reg [(pDATA_WIDTH-1) : 0]               tap_data_wbuff_nxt ;
reg                                     tap_addr_wbuff_v ;
reg                                     tap_addr_wbuff_v_nxt ;
reg                                     tap_data_wbuff_v ;
reg                                     tap_data_wbuff_v_nxt ;
wire                                    tap_write ;
reg                                     tap_read ;
reg                                     tap_read_done;
reg [(pDATA_WIDTH-1) : 0]               tap_data_rbuff ;
reg [(pDATA_WIDTH-1) : 0]               tap_data_rbuff_nxt ;
reg [(pADDR_WIDTH-1) : 0]               tap_addr_rbuff ;
reg [(pADDR_WIDTH-1) : 0]               tap_addr_rbuff_nxt ;
reg                                     tap_addr_rbuff_v ;
reg                                     tap_addr_rbuff_v_nxt ;
reg                                     tap_data_rbuff_v ;
reg                                     tap_data_rbuff_v_nxt ;
//---------------------- AXI-STREAM interface---------------------//
reg [(pDATA_WIDTH-1) : 0]               data_buff ;
reg [(pDATA_WIDTH-1) : 0]               data_buff_nxt ;

reg                                     data_buff_v ;
reg                                     data_buff_v_nxt ;                                     
reg                                     data_full;
reg                                     data_full_nxt;
wire                                    data_write ;
reg                                     data_write_done;

//------------------------FIR  CONFIG-------------------------------//
reg [(pDATA_WIDTH-1) : 0]               data_len;
wire[(pDATA_WIDTH-1) : 0]               data_len_nxt;
reg [(pDATA_WIDTH-1) : 0]               tap_num;
wire[(pDATA_WIDTH-1) : 0]               tap_num_nxt ;
reg [2:0]                               fir_state ;
reg [2:0]                               fir_state_nxt ;
reg                                     done_check;
reg                                     done_check_nxt;

//----------------------- FIR ENGINE -----------------------------//
reg [(pPOINTER_WIDTH-1) : 0]            x_in_pointer ;
reg [(pPOINTER_WIDTH-1) : 0]            x_in_pointer_nxt;
reg [(pPOINTER_WIDTH-1) : 0]            x_out_pointer;
reg [(pPOINTER_WIDTH-1) : 0]            x_out_pointer_nxt;
reg [(pPOINTER_WIDTH-1) : 0]            h_out_pointer;
reg [(pPOINTER_WIDTH-1) : 0]            h_out_pointer_nxt;
wire[(pPOINTER_WIDTH-1) : 0]            x_pointer_diff_oi;
wire[(pPOINTER_WIDTH-1) : 0]            x_pointer_diff_io;
wire[(pPOINTER_WIDTH-1) : 0]            zero_p;
wire[(pPOINTER_WIDTH-1) : 0]            one_p;
wire[(pPOINTER_WIDTH-1) : 0]            two_p;

wire[(pADDR_WIDTH-1) : 0]               x_in_addr ;
wire[(pADDR_WIDTH-1) : 0]               x_out_addr ;
wire[(pADDR_WIDTH-1) : 0]               h_out_addr ;

reg [(pDATA_WIDTH-1) : 0]               x_dat_reg ;
reg [(pDATA_WIDTH-1) : 0]               h_dat_reg ;
reg [(pDATA_WIDTH-1) : 0]               mul_reg ;
reg [(pDATA_WIDTH-1) : 0]               acc_reg ;
wire[(pDATA_WIDTH-1) : 0]               x_dat_nxt ;
wire[(pDATA_WIDTH-1) : 0]               h_dat_nxt ;
wire[(pDATA_WIDTH-1) : 0]               mul_nxt ;
wire[(pDATA_WIDTH-1) : 0]               acc_nxt ;
wire[(pDATA_WIDTH-1) : 0]               tap_max ;

reg [(pDATA_WIDTH-1) : 0]               y_buff  ;
wire[(pDATA_WIDTH-1) : 0]               y_buff_nxt ;
reg                                     y_buff_v ;
reg                                     y_buff_v_nxt;

reg                                     ss_stall ;
reg                                     ss_stall_nxt;
reg                                     ss_stall_1;
reg                                     sm_stall ;
reg                                     sm_stall_1;
reg                                     acc_clear ;
reg                                     acc_clear_nxt;
reg [(pCOUNTER_WIDTH-1) : 0]            x_counter;
wire[(pCOUNTER_WIDTH-1) : 0]            x_counter_nxt;
reg [(pCOUNTER_WIDTH-1) : 0]            y_counter;
wire[(pCOUNTER_WIDTH-1) : 0]            y_counter_nxt;
wire[(pCOUNTER_WIDTH-1) : 0]            one_count;
wire[(pCOUNTER_WIDTH-1) : 0]            y_lave;
reg                                     sm_tlast_reg;
reg                                     sm_tlast_reg_nxt;
reg                                     x_last_reg;
wire                                    x_last_reg_nxt ;

//---------------------------------- string of zero used for reset -------------------------------------------------------------------------//
wire[(pDATA_WIDTH + pADDR_WIDTH +pCOUNTER_WIDTH - 1) :0]    buff_clear ;
assign buff_clear  = {(pADDR_WIDTH + pDATA_WIDTH + pCOUNTER_WIDTH){1'b0}} ;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          FIR ENGINE (PIPELINE)                                                                           //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
assign  sm_tlast          = sm_tlast_reg;
assign  sm_tvalid         = y_buff_v;
assign  sm_tdata          = y_buff;

//------------------------------------------- pointer of DATA RAM / TAP RAM ----------------------------------------------------------------//
assign x_pointer_diff_oi  = x_out_pointer - x_in_pointer; 
assign x_pointer_diff_io  = x_in_pointer - x_out_pointer; 
assign one_p              = { {(pPOINTER_WIDTH-1){1'b0}} , 1'b1};
assign zero_p             = {(pPOINTER_WIDTH){1'b0}};
assign two_p              = {{(pPOINTER_WIDTH-2){1'b0}} , 2'b10};
assign tap_max            = tap_num[(pPOINTER_WIDTH-1) : 0] - {buff_clear[(pPOINTER_WIDTH-2) : 0] , 1'b1};

always @(*) begin
    if(data_full)begin
        x_in_pointer_nxt  = (x_pointer_diff_oi == one_p || h_out_pointer == tap_max)? (x_in_pointer + one_p) : x_in_pointer;
        x_out_pointer_nxt = (x_pointer_diff_oi == one_p || h_out_pointer == tap_max)? (x_in_pointer + one_p) : (x_out_pointer - one_p) ;
        h_out_pointer_nxt = (x_pointer_diff_oi == one_p || h_out_pointer == tap_max)?                 zero_p : (h_out_pointer + one_p) ;
    end else begin
        x_in_pointer_nxt  = (x_out_pointer == zero_p || h_out_pointer == tap_max)? (x_in_pointer + one_p) : x_in_pointer;
        x_out_pointer_nxt = (x_out_pointer == zero_p || h_out_pointer == tap_max)? (x_in_pointer + one_p) : (x_out_pointer - one_p) ;
        h_out_pointer_nxt = (x_out_pointer == zero_p || h_out_pointer == tap_max)?                 zero_p : (h_out_pointer + one_p) ;
    end
end

always @(posedge axis_clk or negedge axis_rst_n) begin
    if(!axis_rst_n)begin
        x_in_pointer  <= zero_p;
        x_out_pointer <= zero_p;
        h_out_pointer <= zero_p;
    end else if(fir_state == START) begin
        x_in_pointer  <= zero_p;
        x_out_pointer <= zero_p;
        h_out_pointer <= zero_p;
    end else if(fir_state == RUN) begin
        if((!sm_stall) && (!ss_stall))begin
            x_in_pointer  <= x_in_pointer_nxt ;
            x_out_pointer <= x_out_pointer_nxt;
            h_out_pointer <= h_out_pointer_nxt;
        end
    end
end

//------------------------------------------------------- PIPELINE STAGE ------------------------------------------------------------------//
assign x_dat_nxt        = (data_write_done)? data_buff : data_Do;
assign h_dat_nxt        = tap_Do;
assign mul_nxt          = x_dat_reg * h_dat_reg;
assign acc_nxt          = (acc_clear)? mul_reg : (mul_reg + acc_reg);
assign y_buff_nxt       = (acc_clear)? acc_reg : y_buff ;
assign x_counter_nxt    = (ss_tvalid && ss_tready)? (x_counter + one_count) : x_counter;
assign y_counter_nxt    = (sm_tvalid && sm_tready)? (y_counter + one_count) : y_counter;
assign y_lave           = data_len - y_counter;
assign one_count        = {{(pCOUNTER_WIDTH-1){1'b0}} , 1'b1};
assign x_last_reg_nxt   = (x_counter_nxt == data_len)? 1'b1 : x_last_reg ;


always @(*) begin
    if(!sm_tlast_reg)begin
        sm_tlast_reg_nxt = (y_lave == one_count)? y_buff_v_nxt : 1'b0;
    end else begin
        sm_tlast_reg_nxt = sm_tlast_reg;
    end
end

always @(*) begin
    if(x_pointer_diff_io == two_p)begin
        acc_clear_nxt = 1'b1;
    end else begin
        if(data_full)begin
            acc_clear_nxt = 1'b0;
        end else begin
            acc_clear_nxt = (x_in_pointer == two_p)? ((x_out_pointer == two_p)? 1'b1 : 1'b0) : 1'b0; 
        end
    end
end

always @(*) begin
    sm_stall = (acc_clear_nxt || acc_clear)? y_buff_v : 1'b0;
end

always @(*) begin
    if(x_last_reg)begin
        ss_stall_nxt = 1'b0;
    end else if(ss_stall)begin
        ss_stall_nxt = (data_buff_v_nxt)? 1'b0 : 1'b1;
    end else begin
        if(data_full)begin
            ss_stall_nxt = (x_pointer_diff_oi == one_p || h_out_pointer == tap_max)? ((data_buff_v_nxt)? 1'b0 : 1'b1) : 1'b0;
        end else begin
            ss_stall_nxt = (x_out_pointer == zero_p || h_out_pointer == tap_max)? ((data_buff_v_nxt)? 1'b0 : 1'b1) : 1'b0;
        end
    end
end

always @(*) begin
    //*  valid bit of output buffer (1:valid / 0: invalid)
    if(y_buff_v)begin
        y_buff_v_nxt = (sm_tready)? 1'b0 : 1'b1;
    end else begin
        y_buff_v_nxt = (acc_clear && (!sm_stall_1) && (!ss_stall_1))? 1'b1 : 1'b0;
    end
end

always @(posedge axis_clk or negedge axis_rst_n ) begin
    if(!axis_rst_n)begin
        sm_tlast_reg <= 1'b0;
        y_buff_v     <= 1'b0;
        ss_stall     <= 1'b1;
        ss_stall_1   <= 1'b1;
        sm_stall_1   <= 1'b0;
        x_last_reg   <= 1'b0;
        x_counter    <= buff_clear[(pCOUNTER_WIDTH-1) : 0];
        y_counter    <= buff_clear[(pCOUNTER_WIDTH-1) : 0];
    end else if(fir_state == START) begin
        sm_tlast_reg <= 1'b0;
        y_buff_v     <= 1'b0;
        ss_stall     <= 1'b1;
        ss_stall_1   <= 1'b1;
        sm_stall_1   <= 1'b0;
        x_last_reg   <= 1'b0;
        x_counter    <= buff_clear[(pCOUNTER_WIDTH-1) : 0];
        y_counter    <= buff_clear[(pCOUNTER_WIDTH-1) : 0];
    end else if(fir_state == RUN) begin
        sm_tlast_reg <= sm_tlast_reg_nxt;
        y_buff_v     <= y_buff_v_nxt ;
        ss_stall     <= ss_stall_nxt ;
        ss_stall_1   <= ss_stall;
        sm_stall_1   <= sm_stall;
        x_last_reg   <= x_last_reg_nxt;
        x_counter    <= x_counter_nxt;
        y_counter    <= y_counter_nxt;
    end
end

always @(posedge axis_clk or negedge axis_rst_n) begin
    if(!axis_rst_n)begin
        x_dat_reg <= buff_clear[(pDATA_WIDTH-1) : 0];
        h_dat_reg <= buff_clear[(pDATA_WIDTH-1) : 0];
        mul_reg   <= buff_clear[(pDATA_WIDTH-1) : 0];
        acc_reg   <= buff_clear[(pDATA_WIDTH-1) : 0];
        y_buff    <= buff_clear[(pDATA_WIDTH-1) : 0];
        acc_clear <= 1'b0;
    end else if(fir_state == START) begin
        x_dat_reg <= buff_clear[(pDATA_WIDTH-1) : 0];
        h_dat_reg <= buff_clear[(pDATA_WIDTH-1) : 0];
        mul_reg   <= buff_clear[(pDATA_WIDTH-1) : 0];
        acc_reg   <= buff_clear[(pDATA_WIDTH-1) : 0];
        y_buff    <= buff_clear[(pDATA_WIDTH-1) : 0];
        acc_clear <= 1'b0;
    end else if(fir_state == RUN) begin
        if((!sm_stall_1) && (!ss_stall_1))begin
            x_dat_reg <= x_dat_nxt;
            h_dat_reg <= h_dat_nxt;
            mul_reg   <= mul_nxt  ;
            acc_reg   <= acc_nxt  ;
            y_buff    <= y_buff_nxt ;
            acc_clear <= acc_clear_nxt;
        end
    end
end
//----------------------------------------------------------------------------------------------------------------------------------------------------//



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                          AXI-STREAM INTERFACE (DATA INPUT)                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign ss_tready          = (axis_rst_n && (!fir_state[2]) && (!x_last_reg))? (!data_buff_v) : 1'b0;
    assign x_in_addr          = {buff_clear[(pADDR_WIDTH-pPOINTER_WIDTH-1) :0] , x_in_pointer , 2'b00};
    assign x_out_addr         = {buff_clear[(pADDR_WIDTH-pPOINTER_WIDTH-1) :0] , x_out_pointer , 2'b00};
    assign data_A             = (data_WE[0])? x_in_addr : x_out_addr ;
    assign data_Di            = data_buff;    
    assign data_EN            = (fir_state == RUN)?  1'b1 : 1'b0;
    assign data_WE            = data_write?  4'b1111 : 4'b0000; 
    assign data_write         = (x_pointer_diff_io != zero_p)? 1'b0 : ((!sm_stall) && (data_buff_v));
  
    

    always @(*) begin
        if(data_full)begin
            data_full_nxt = data_full ;
        end else begin
            data_full_nxt = (x_in_pointer == pRAM_ADDR_MAX)? data_write : 1'b0;
        end
    end

    always @(posedge axis_clk or negedge axis_rst_n) begin
        if(!axis_rst_n)begin
            data_buff       <= buff_clear[(pDATA_WIDTH-1) : 0];
            data_buff_v     <= 1'b0;
            data_full       <= 1'b0;
            data_write_done <= 1'b0;
        end else if(fir_state == START)begin
            data_buff       <= buff_clear[(pDATA_WIDTH-1) : 0];
            data_buff_v     <= 1'b0;
            data_full       <= 1'b0;
            data_write_done <= 1'b0;
        end else if (fir_state == RUN)begin
            data_buff       <= data_buff_nxt;
            data_buff_v     <= data_buff_v_nxt;
            data_full       <= data_full_nxt ;
            data_write_done <= data_write;
        end
    end

    always @(*) begin
        if(data_buff_v)begin
            data_buff_nxt = data_buff;
        end else begin
            data_buff_nxt = (ss_tvalid)? ss_tdata : data_buff; 
        end
    end

    always @(*) begin
        if(data_buff_v)begin
            data_buff_v_nxt = (data_WE[0])? 1'b0 : data_buff_v;
        end else begin
            data_buff_v_nxt = (ss_tvalid)?  1'b1 : data_buff_v;
        end
    end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                           AXI-LITE INTERFACE                                                                       //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        assign  awready     = (axis_rst_n)? (!tap_addr_wbuff_v ) : 1'b0;
        assign  wready      = (axis_rst_n)? (!tap_data_wbuff_v ) : 1'b0;
        assign  arready     = (axis_rst_n)? (!tap_addr_rbuff_v)  : 1'b0;
        assign  rvalid      = tap_data_rbuff_v ;
        assign  rdata       = tap_data_rbuff;
        assign  h_out_addr  = {buff_clear[(pADDR_WIDTH-pPOINTER_WIDTH-1) : 0] , h_out_pointer , 2'b00};

        assign  tap_WE      = (fir_state != RUN)?  (((tap_addr_wbuff >= tap_para_base))? {tap_write , tap_write , tap_write , tap_write} : 4'b0000) : 4'b0000 ;
        assign  tap_EN      = (fir_state != RUN)?  (tap_WE[0] || tap_read || tap_read_done) : 1'b1;
        assign  tap_Di      = tap_data_wbuff ;
        assign  tap_A       = (fir_state != RUN)?  ((tap_WE)? (tap_addr_wbuff - tap_ram_base) : (tap_addr_rbuff - tap_ram_base)): h_out_addr  ;

        assign  tap_write   = (tap_addr_wbuff_v && tap_data_wbuff_v)? 1'b1 : 1'b0;

        always @(*) begin
            if((tap_addr_wbuff_v_nxt && tap_data_wbuff_v_nxt) || (tap_data_wbuff_v && tap_addr_wbuff_v) || rvalid)begin
                tap_read = 1'b0;
            end else begin 
                tap_read = (tap_addr_rbuff_v && (!rvalid))? 1'b1 : 1'b0;
            end
        end

        always @(*) begin
            //* tap buffer for writing (address + data)
            tap_addr_wbuff_nxt = (awvalid && (!tap_addr_wbuff_v))? awaddr : tap_addr_wbuff ;   
            tap_data_wbuff_nxt = (wvalid  && (!tap_data_wbuff_v))? wdata  : tap_data_wbuff ;
        end

        always @(*) begin
            //* tap buffer's address valid bit for writing 
            if(tap_addr_wbuff_v)begin
                tap_addr_wbuff_v_nxt = (tap_write)?  1'b0 : 1'b1 ;
            end else begin
                tap_addr_wbuff_v_nxt = (awvalid)? 1'b1 : 1'b0 ;
            end
        end

        always @(*) begin
            //* tap buffer's data valid bit for writing
            if(tap_data_wbuff_v)begin
                tap_data_wbuff_v_nxt = (tap_write)? 1'b0 : 1'b1 ; 
            end else begin
                tap_data_wbuff_v_nxt = (wvalid)? 1'b1 : 1'b0 ;
            end
        end

        always @(posedge axis_clk or negedge axis_rst_n) begin
            //* register type tap_buffer for writing
            if(!axis_rst_n)begin
                tap_addr_wbuff      <=  buff_clear[(pADDR_WIDTH-1) :0] ;
                tap_data_wbuff      <=  buff_clear[(pDATA_WIDTH-1) :0] ;
                tap_data_wbuff_v    <=  1'b0;
                tap_addr_wbuff_v    <=  1'b0;
            end else begin
                tap_addr_wbuff      <=  tap_addr_wbuff_nxt ;
                tap_data_wbuff      <=  tap_data_wbuff_nxt ;
                tap_data_wbuff_v    <=  tap_data_wbuff_v_nxt;
                tap_addr_wbuff_v    <=  tap_addr_wbuff_v_nxt;    
            end
        end

        always @(*)begin
            if(tap_read_done)begin
                if(tap_addr_rbuff < tap_para_base)begin
                    case(tap_addr_rbuff[(pCONFIG_REF-1):0])
                        ap_base         : tap_data_rbuff_nxt = {{(pDATA_WIDTH-6){1'b0}}, sm_tvalid , ss_tready , 1'b0, fir_state};
                        dat_len_base    : tap_data_rbuff_nxt = data_len ;
                        tap_num_base    : tap_data_rbuff_nxt = tap_num ;
                        default         : tap_data_rbuff_nxt = INVALID_VALUE ;
                    endcase
                end else begin
                    tap_data_rbuff_nxt = (fir_state == RUN)?   INVALID_VALUE : tap_Do ;
                end
            end else begin
                tap_data_rbuff_nxt = tap_data_rbuff ;
            end
        end
        always @(*) begin
            if(tap_addr_rbuff_v)begin
                //* after reading request(tap_read) send , invalidate read_address_buffer's valid bit
                tap_addr_rbuff_v_nxt = (tap_read)?  1'b0 : 1'b1;
            end else begin
                //* if read buff is no address in valid , we pull down valid bit  
                tap_addr_rbuff_v_nxt = (arvalid)?   1'b1 : 1'b0;
            end
        end

        always @(*) begin
            if(!tap_data_rbuff_v)begin
                tap_data_rbuff_v_nxt = (tap_read_done)?  1'b1 : 1'b0;
            end else begin  
                tap_data_rbuff_v_nxt = (rready)?   1'b0 : 1'b1;
            end
        end

        always @(*)begin
            if(!tap_addr_rbuff_v)begin
                //* buffer catch the address while there is not read address in buffer
                tap_addr_rbuff_nxt = (arvalid)? araddr : tap_addr_rbuff ;
            end else begin
                tap_addr_rbuff_nxt = tap_addr_rbuff ;
            end
        end

        always @(posedge axis_clk or negedge axis_rst_n) begin
            //* register type tap_buff for reading
            if(!axis_rst_n)begin
                tap_addr_rbuff      <=  buff_clear[(pADDR_WIDTH-1) :0] ;
                tap_data_rbuff      <=  buff_clear[(pDATA_WIDTH-1) :0] ;
                tap_data_rbuff_v    <=  1'b0;
                tap_addr_rbuff_v    <=  1'b0;
                tap_read_done       <=  1'b0;
            end else begin
                tap_addr_rbuff      <=  tap_addr_rbuff_nxt ;
                tap_data_rbuff      <=  tap_data_rbuff_nxt ;
                tap_data_rbuff_v    <=  tap_data_rbuff_v_nxt;
                tap_addr_rbuff_v    <=  tap_addr_rbuff_v_nxt;    
                tap_read_done       <=  tap_read;
            end
        end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                            FIR CONFIG                                                                            //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        assign data_len_nxt = (tap_write)? ((tap_addr_wbuff[(pCONFIG_REF-1) : 0] == dat_len_base)? tap_data_wbuff : data_len ) : data_len ;
        assign tap_num_nxt  = (tap_write)? ((tap_addr_wbuff[(pCONFIG_REF-1) : 0] == tap_num_base)? tap_data_wbuff : tap_num  ) : tap_num ;

 
        always @(*) begin
            if(!done_check)begin
                done_check_nxt = (tap_read_done && fir_state[1])? ((tap_addr_rbuff[(pCONFIG_REF-1) : 0] == ap_base)? 1'b1 : 1'b0) : 1'b0; 
            end else begin
                done_check_nxt = (rready)? 1'b0 : done_check ;
            end
        end

        always @(*) begin
            case(fir_state)
                IDLE  : begin
                    if(tap_write)begin
                        fir_state_nxt = (tap_addr_wbuff[(pCONFIG_REF-1) : 0] == ap_base)?  ((tap_data_wbuff[0])? START : IDLE) : IDLE ;
                    end else begin
                        fir_state_nxt = IDLE ;
                    end
                end
                START : begin
                    fir_state_nxt = RUN ;
                end
                RUN   : begin
                    fir_state_nxt = (sm_tlast && sm_tready)? DONE : RUN ;
                end
                DONE  : begin
                    if(done_check)begin
                        fir_state_nxt = (rready)? IDLE : DONE ;
                    end else if(tap_write)begin
                        fir_state_nxt = (tap_addr_wbuff[(pCONFIG_REF-1) : 0] == ap_base)?  ((tap_data_wbuff[0])? START : DONE) : DONE ;
                    end else begin
                        fir_state_nxt = DONE ;
                    end  
                end
                default : fir_state_nxt = IDLE ;
            endcase
        end

        always @(posedge axis_clk or negedge axis_rst_n) begin
            if(!axis_rst_n)begin
                fir_state   <= IDLE ;
                done_check  <= 1'b0;
            end else begin
                fir_state   <= fir_state_nxt ;
                done_check  <= done_check_nxt;
            end
        end

        always @(posedge axis_clk or negedge axis_rst_n) begin
            if(!axis_rst_n)begin
                data_len <= buff_clear[(pDATA_WIDTH-1) : 0];
                tap_num  <= buff_clear[(pDATA_WIDTH-1) : 0];
            end else if (tap_write) begin
                if(fir_state != RUN)begin
                    data_len <= data_len_nxt ;
                    tap_num  <= tap_num_nxt ;
                end
            end
        end
endmodule

module bram32 (clk, we, re, waddr, raddr, wdi, rdo);
    parameter ADDR_WIDTH = 12;
    parameter SIZE = 32;
    parameter BIT_WIDTH = 32;
    input                          clk;
    input                          we, re;
    input [ADDR_WIDTH-1:0]         waddr, raddr;
    input [BIT_WIDTH-1:0]          wdi;
    output reg [BIT_WIDTH-1:0]     rdo;
    reg [BIT_WIDTH-1:0] RAM [SIZE-1:0];
    
    always @(posedge clk)begin
        if(re) rdo <= RAM[raddr>>2];
    end
    
    always @(posedge clk)begin
        if(we) RAM[waddr>>2] <= wdi;
    end
    
endmodule

`default_nettype wire
