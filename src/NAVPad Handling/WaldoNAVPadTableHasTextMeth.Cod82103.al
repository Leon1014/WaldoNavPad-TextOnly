codeunit 82103 "WaldoNAVPad TableHasText Meth"
{
    trigger OnRun();
    begin
    end;

    procedure TableHasTexts(TableNo: Integer) ResultHasTexts: Boolean;
    var
        Handled: Boolean;
    begin
        OnBeforeTableHasTexts(TableNo, ResultHasTexts, Handled);
        ResultHasTexts := DoTableHasTexts(TableNo, Handled);
        OnAfterTableHasTexts(TableNo);
    end;

    local procedure DoTableHasTexts(var TableNo: Integer; Handled: Boolean): Boolean;
    begin
        if Handled then exit;

        exit(HasTextsForRecRef(TableNo));
    end;

    local procedure HasTextsForRecRef(var pTableNo: Integer): Boolean;
    var
        WaldoNAVPadBlobstore: Record "WaldoNAVPad Blobstore";
    begin
        WaldoNAVPadBlobstore.SetRange(TableNo, pTableNo);
        exit(not WaldoNAVPadBlobstore.IsEmpty());
    end;

    local procedure "--- Event Wrapper"();
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTableHasTexts(var TableNo: Integer; var ResultHasTexts: Boolean; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTableHasTexts(var TableNo: Integer);
    begin
    end;
}

