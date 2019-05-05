module controller (input cntdone, clk, rst,start, 
		output reg cntinit,cnten,init,xsel,romsel,x2sel,x2multsel,xlden,tanlden,termxsel,multsel,termlden,ready,busy, output [2:0] ptest, ntest);
		reg[2:0] ns = 0;
		reg[2:0] ps;
		parameter[2:0] idle = 0, starting = 1, loading = 2, calcx2 = 3, tg1 = 4, termcalc = 5;
        always @ (start,ps,cntdone) begin
            ns = 0;
            ready = 0;
            busy = 1;
            init = 0;
            cntinit = 0;
            xsel = 0;
            termxsel = 0;
            xlden = 0;
            termlden = 0;
            x2multsel = 0;
            x2sel = 0;
            romsel = 0;
            tanlden = 0;
            cnten = 0;
            multsel = 0;
            case(ps)
            idle: begin
                ns = start ? starting: idle;
                ready = 1;
				busy = 0;
            end
            starting: begin
					ns = start? starting : loading;
					busy = 0;
				end	
            loading: begin
                ns = calcx2;
                cntinit = 1;
                init = 1;
                xsel = 1;
                termxsel = 1;
                xlden = 1;
                termlden = 1;
            end
            calcx2: begin
                ns = tg1;
                x2multsel = 1;
                x2sel = 1;
                xlden = 1;
					 cnten = 1;
            end
            tg1: begin
                ns = cntdone ? idle : termcalc;
                romsel = 1;
                tanlden = 1;
            end
            termcalc: begin
                ns = cntdone ? idle : tg1;
                x2multsel = 1;
                multsel = 1;
                termlden = 1;
					 cnten = 1;
            end
				default: ns = idle;
            endcase
        end
        always @(posedge clk, posedge rst) begin
            if (rst) ps <= idle;
            else ps <= ns;
        end
		  assign ptest = ps;
		  assign ntest = ns;
endmodule