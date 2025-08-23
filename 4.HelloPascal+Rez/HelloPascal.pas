program HelloPascalR (input,output);
uses Common, QuickDrawII, ResourceMgr;
const
      rPString = $8006;
type
  pnt =  ^char; 
  hnd =  ^pnt;   

var
        myhnd : handle;
        err,tempo : integer; 
        s : pString;

procedure IntToStr(n: integer; var s : pString);
{ Converts an integer to a hexadecimal string representation }
{ The integer is expected to be in the range 0 to 65535 }
{ The string will be formatted as a 4-character hexadecimal number }
{ Example: 255 will be converted to '00FF' }
{ The string is stored in the variable 's' passed by reference }
var
        tempo : integer;
begin
        s := '';
        tempo := n & 15;
        if tempo < 10 then
                s :=  chr(tempo + ord('0'))
        else
                s := chr(tempo - 10 + ord('A'));

        tempo := (n & 240) div 16;
        if tempo < 10 then
                s := concat (chr(tempo + ord('0')), s)
        else
                s := concat (chr(tempo - 10 + ord('A')), s);

        tempo := (n & 3840) div 256;
        if tempo < 10 then
                s := concat (chr(tempo + ord('0')), s)
        else
                s := concat (chr(tempo - 10 + ord('A')), s);

        tempo := n div 4096;
        if tempo < 10 then
                s := concat (chr(tempo + ord('0')), s)
        else
                s := concat (chr(tempo - 10 + ord('A')), s);         
end;


begin
        StartGraph(320);
        PenNormal;

        {GetPString}
        myhnd := LoadResource(rPString, 1);
        err := ToolError;
        if myhnd <> nil then
        begin
                MoveTo(50, 50);
                writeln('Resource loaded successfully');  
        end
        else
        begin
                MoveTo(50, 50);
                writeln('Failed to load resource');

                { Display the error code in hexadecimal format }
                IntToStr(err, s);
                writeln('Error code in hex: ', concat('$', s));
        end;

        writeln('Press Enter to exit...');
        readln;  { Wait for user input before closing the program }

        EndGraph;
end.

