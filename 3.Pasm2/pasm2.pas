{ Demonstrate calling assembly language functions from Pascal. }
program FunctionIt (output);
function reverse (a: integer): integer; extern;
procedure keypress; extern;

begin
        writeln ('Number  =', 6);
        writeln ('Reversed =', reverse(6));
        writeln ('Reversed again =', reverse(reverse(6)));
        writeln;
        writeln ('Press Enter to quit...');
        keypress;
end.
{$append 'pasm2.asm'}