codeunit 82111 "WaldoNAVPad Text Parse Meth"
{
    trigger OnRun();
    begin
    end;

    procedure ParseText(var Text: Text; MaxLength: Integer; var ResultWaldoNAVPadTextBuffer: Record "WaldoNAVPad Text Buffer");
    var
        Handled: Boolean;
    begin
        OnBeforeParseText(Text, Handled);
        DoParseText(Text, MaxLength, ResultWaldoNAVPadTextBuffer, Handled);
        OnAfterParseText(Text);
    end;

    local procedure DoParseText(var myText: Text; MaxLength: Integer; var ResultWaldoNAVPadTextBuffer: Record "WaldoNAVPad Text Buffer"; var Handled: Boolean);
    var
        SystemString: Text;
        LineArray: List of [Text];
        Line: Text;
        LineNo: Integer;
        char10: char;
        char13: char;
    begin
        if Handled then exit;

        SystemString := myText;

        ResultWaldoNAVPadTextBuffer.DELETEALL(false);

        char10 := 10;
        char13 := 13;
        LineArray := myText.Split(char10, char13);
        foreach Line in LineArray do
            ProcessLine(LineNo, Line, MaxLength, ResultWaldoNAVPadTextBuffer);

        RemoveLastCarriageReturn(ResultWaldoNAVPadTextBuffer);
    end;

    local procedure ProcessLine(var LineNo: Integer; var Line: Text; MaxLength: Integer; var ResultWaldoNAVPadTextBuffer: Record "WaldoNAVPad Text Buffer");
    var
        SubString: Text;
        SpaceIndex: Integer;
        ResultString: Text;
    begin
        while STRLEN(Line) > MaxLength do begin
            SubString := COPYSTR(Line, 1, MaxLength);
            SpaceIndex := SubString.LastIndexOf(' ');
            if SpaceIndex = 0 then //No Space Found
                SpaceIndex := MaxLength;
            if SpaceIndex = 1 then //First Character is a space
                SpaceIndex := MaxLength;

            ResultString := SubString;
            if SpaceIndex < strlen(SubString) then begin
                ResultString := SubString.Substring(1, SpaceIndex);
                AddToBuffer(LineNo, ResultString, ResultWaldoNAVPadTextBuffer.Separator::" ", ResultWaldoNAVPadTextBuffer);
            end else begin
                AddToBuffer(LineNo, ResultString.Substring(1, SpaceIndex - 1), ResultWaldoNAVPadTextBuffer.Separator::Space, ResultWaldoNAVPadTextBuffer);
            end;

            Line := Line.Remove(1, strlen(ResultString));
        end;

        AddToBuffer(LineNo, Line, ResultWaldoNAVPadTextBuffer.Separator::"Carriage Return", ResultWaldoNAVPadTextBuffer);
    end;

    local procedure AddToBuffer(var LineNo: Integer; Line: Text; pSeparator: Integer; var ResultWaldoNAVPadTextBuffer: Record "WaldoNAVPad Text Buffer");
    begin
        LineNo += 1;

        ResultWaldoNAVPadTextBuffer.Init();
        ResultWaldoNAVPadTextBuffer."Line No." := LineNo;
        ResultWaldoNAVPadTextBuffer.Textline := CopyStr(Line, 1, 250);
        ResultWaldoNAVPadTextBuffer.Separator := pSeparator;
        ResultWaldoNAVPadTextBuffer.Insert();
    end;

    local procedure RemoveLastCarriageReturn(var ResultWaldoNAVPadTextBuffer: Record "WaldoNAVPad Text Buffer")
    begin
        ResultWaldoNAVPadTextBuffer.FindLast();
        ResultWaldoNAVPadTextBuffer.Separator := ResultWaldoNAVPadTextBuffer.Separator::" ";
        ResultWaldoNAVPadTextBuffer.Modify();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeParseText(var Text: Text; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterParseText(var Text: Text);
    begin
    end;
}

