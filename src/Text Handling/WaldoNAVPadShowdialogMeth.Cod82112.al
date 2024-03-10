codeunit 82112 "WaldoNAVPad Showdialog Meth"
{
    trigger OnRun();
    begin
    end;

    procedure ShowDialog(var Text: Text; var HTML: Text; var DialogResultTrue: Boolean; Editable: Boolean);
    var
        Handled: Boolean;
    begin
        OnBeforeShowDialog(Text, HTML, Editable, Handled);
        DoShowDialog(Text, HTML, DialogResultTrue, Editable, Handled);
        OnAfterShowDialog(Text, HTML, Editable);
    end;

    local procedure DoShowDialog(var Text: Text; var HTML: Text; var DialogResultTrue: Boolean; Editable: Boolean; var Handled: Boolean);
    begin
        if Handled then
            exit;

        ShowTextOnPage(Text, HTML, DialogResultTrue, Editable);
    end;

    local procedure ShowTextOnPage(var Text: Text; var HTML: Text; var DialogResultTrue: Boolean; Editable: Boolean);
    var
        WaldoNAVPad: Page WaldoNAVPad;
    begin
        WaldoNAVPad.SetText(Text);
        WaldoNAVPad.LOOKUPMODE := true;
        WaldoNAVPad.EDITABLE := Editable;

        if WaldoNAVPad.RUNMODAL() = ACTION::LookupOK then begin
            Text := WaldoNAVPad.GetText();
            HTML := Text;

            DialogResultTrue := true;
        end;
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforeShowDialog(var Text: Text; var HTML: Text; Editable: Boolean; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterShowDialog(var Text: Text; var HTML: Text; Editable: Boolean);
    begin
    end;
}

