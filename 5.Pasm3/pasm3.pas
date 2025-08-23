{ Demonstrate calling assembly language functions from Pascal. }
program Vardebug (output);
uses Common, QuickDrawII, TextToolSet;

var
  num, num2: integer;
  s : cstring;
  tohex : pstring;
  strAddress : longint;
  li : longint;

procedure debug; extern;
{used for breaking a program by setting conditions for breakpoints}

function debug2 (i: integer): integer; extern;
{puts the value of i into X and A for debugging}

function debug4 (p: ptr): longint; extern;
{puts pointer p in X/A for debugging and returns the pointer value}

function dblong(l: longint): longint; extern;

procedure keypress; extern;
{used to wait for a key press}

procedure IntToHex(n: longint; var hexstr: pstring);
{Convert a long integer to a hexadecimal string}
var
  i: Integer;
  index : Integer;
  HexChars: string[16];  

begin
  HexChars := '0123456789ABCDEF';
  hexstr := '';
  for i := 7 downto 0 do
  begin
    index := integer((n >> (i * 4)) & 15)+1;
    hexstr := concat(hexstr, HexChars[index]);
  end;
end;

begin
        StartGraph(320); {start super hires mode, init QuickDraw II, ...}
        MoveTo(3, 40);

        writeln('      -- Pascal/Assembly integration --');
        writeln;

        {demo of debug2}
        num := 6;
        writeln ('Number  : ', num);
        num2 := debug2(num);            {call assembly function}
        writeln ('Number caught by debug2 assembly routine  : ', num2);
        writeln;

        {demo of debug4}
        s := 'Test string';
        writeln('C string : ', s);
        strAddress := debug4(s);                    {address of parameter (@s) will be in X (hi word), A (lo word)}
        IntToHex(strAddress, tohex);
        writeln ('Address of C string caught by debug4 assembly routine : ');
        writeln (concat('$',tohex));
        writeln;

        li := 1234;
        writeln('Longint : ', li);
        writeln('Longint x 2 by assembly routine : ', dblong(li));

        writeln;
        writeln ('Press any key to quit...');
        keypress;
        EndGraph;
end.
{$append 'pasm3.s'}