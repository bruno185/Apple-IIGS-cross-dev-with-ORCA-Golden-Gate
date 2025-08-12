program Hello (input,output);
uses Common, QuickDrawII, ResourceMgr;

begin
        StartGraph(320); 
        MoveTo(50, 100);
        writeln('Press Enter to exit...');
        readln;  { Wait for user input before closing the program }
        EndGraph;
end.