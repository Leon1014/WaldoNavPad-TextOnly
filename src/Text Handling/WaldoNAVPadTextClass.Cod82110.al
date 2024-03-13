codeunit 82110 "WaldoNAVPad Text Class"
{
    trigger OnRun();
    begin
    end;

    var
        WaldoNAVPadTextBuffer: Record "WaldoNAVPad Text Buffer" temporary;
        MaxLength: Integer;
        CurrentText: Text;
        CurrentHTML: Text;
        CurrentTextIsUpdated: Boolean;

    procedure Initialize(var Text: Text; pMaxLength: Integer);
    begin
        SetMaxLength(pMaxLength);
        CurrentText := Text;
        CurrentHTML := Text;
        ParseText(CurrentText);

        FINDFIRST();
    end;

    procedure LoadTextFromDialog(Editable: Boolean);
    var
        WaldoNAVPadShowdialogMeth: Codeunit "WaldoNAVPad Showdialog Meth";
    begin
        WaldoNAVPadShowdialogMeth.ShowDialog(CurrentText, CurrentHTML, CurrentTextIsUpdated, Editable);

        if Editable then
            ParseText(CurrentText);
    end;

    procedure GetTextIsUpdated(): Boolean;
    begin
        exit(CurrentTextIsUpdated);
    end;

    procedure GetHTML(): Text;
    begin
        if CurrentHTML = '' then
            exit(CurrentText)
        else
            exit(CurrentHTML);
    end;

    procedure SetMaxLength(pMaxLength: Integer);
    begin
        if MaxLength = 0 then //Max length not being 0 means a custom length was set beforehand.
            MaxLength := pMaxLength;
    end;

    procedure GetMaxLength(): Integer;
    begin
        exit(MaxLength);
    end;

    procedure GetCurrentTextLine(): Text;
    begin
        exit(WaldoNAVPadTextBuffer.Textline);
    end;

    procedure GetSeparator(): Integer;
    begin
        exit(WaldoNAVPadTextBuffer.Separator);
    end;

    procedure FINDFIRST(): Boolean;
    begin
        exit(WaldoNAVPadTextBuffer.FINDSET());
    end;

    procedure "COUNT"(): Integer;
    begin
        exit(WaldoNAVPadTextBuffer.COUNT());
    end;

    procedure NEXT(): Integer;
    begin
        exit(WaldoNAVPadTextBuffer.NEXT());
    end;

    local procedure ParseText(var Text: Text);
    var
        WaldoNAVPadTextParseMeth: Codeunit "WaldoNAVPad Text Parse Meth";
    begin
        WaldoNAVPadTextParseMeth.ParseText(Text, GetMaxLength(), WaldoNAVPadTextBuffer);
    end;
}

