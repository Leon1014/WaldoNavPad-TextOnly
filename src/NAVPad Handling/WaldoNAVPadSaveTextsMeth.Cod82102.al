codeunit 82102 "WaldoNAVPad SaveTexts Meth"
{
    trigger OnRun();
    begin
    end;

    procedure SaveTexts(var WaldoNAVPadTextClass: Codeunit "WaldoNAVPad Text Class"; var RecRef: RecordRef);
    var
        Handled: Boolean;
    begin
        OnBeforeSaveTexts(Handled);

        DoSaveTexts(WaldoNAVPadTextClass, RecRef, Handled);

        OnAfterSaveTexts();
    end;

    local procedure DoSaveTexts(var WaldoNAVPadTextClass: Codeunit "WaldoNAVPad Text Class"; var RecRef: RecordRef; var Handled: Boolean);
    begin
        if Handled then exit;

        if not WaldoNAVPadTextClass.GetTextIsUpdated() then exit;

        UpdateTextForRecord(WaldoNAVPadTextClass, RecRef);
    end;

    local procedure UpdateTextForRecord(var WaldoNAVPadTextClass: Codeunit "WaldoNAVPad Text Class"; var RecRef: RecordRef);
    begin
        SaveTextToBlob(WaldoNAVPadTextClass.GetHTML(), RecRef);
        SaveTextToRecords(WaldoNAVPadTextClass, RecRef);
    end;

    local procedure FilterWaldoNAVPadTexts(var WaldoNAVPadTextstore: Record "WaldoNAVPad Textstore"; var RecRef: RecordRef);
    begin
        WaldoNAVPadTextstore.SetRange("Record ID", RecRef.RECORDID());
    end;

    local procedure SaveTextToBlob(Text: Text; var RecRef: RecordRef);
    begin
        DeleteWaldoNAVPadBlobForRecord(RecRef);
        InsertWPNBlobForRecord(Text, RecRef);
    end;

    local procedure DeleteWaldoNAVPadBlobForRecord(var RecRef: RecordRef);
    var
        WaldoNAVPadBlobstore: Record "WaldoNAVPad Blobstore";
    begin
        WaldoNAVPadBlobstore.SetRange("Record ID", RecRef.RecordId());
        WaldoNAVPadBlobstore.DeleteAll(false);
    end;

    local procedure InsertWPNBlobForRecord(var Text: Text; var RecRef: RecordRef);
    var
        WaldoNAVPadBlobstore: Record "WaldoNAVPad Blobstore";
        Writer: OutStream;
        TextBigText: BigText;
    begin
        WaldoNAVPadBlobstore.Init();
        WaldoNAVPadBlobstore."Record ID" := RecRef.RecordId();
        WaldoNAVPadBlobstore.Blob.CreateOutStream(Writer);
        TextBigText.AddText(Text);
        TextBigText.Write(Writer);
        WaldoNAVPadBlobstore.TableNo := RecRef.Number();
        WaldoNAVPadBlobstore.Insert();
    end;

    local procedure SaveTextToRecords(var WaldoNAVPadTextClass: Codeunit "WaldoNAVPad Text Class"; var RecRef: RecordRef);
    begin
        DeleteWaldoNAVPadTextForRecord(RecRef);
        InsertWPNTextForRecord(WaldoNAVPadTextClass, RecRef);
    end;

    local procedure DeleteWaldoNAVPadTextForRecord(var RecRef: RecordRef);
    var
        WaldoNAVPadTextstore: Record "WaldoNAVPad Textstore";
    begin
        FilterWaldoNAVPadTexts(WaldoNAVPadTextstore, RecRef);
        WaldoNAVPadTextstore.DELETEALL(false);
    end;

    local procedure InsertWPNTextForRecord(var WaldoNAVPadTextClass: Codeunit "WaldoNAVPad Text Class"; var RecRef: RecordRef);
    begin
        if WaldoNavPadTextClass.FINDFIRST() then begin
            repeat
                InsertWPNText(WaldoNAVPadTextClass, RecRef);
            until WaldoNAVPadTextClass.NEXT() < 1;
        end;
    end;

    local procedure InsertWPNText(var WaldoNAVPadTextClass: Codeunit "WaldoNAVPad Text Class"; var RecRef: RecordRef);
    var
        WaldoNAVPadTextstore: Record "WaldoNAVPad Textstore";
    begin
        WaldoNAVPadTextstore.Init();
        WaldoNAVPadTextstore."Record ID" := RecRef.RecordId();
        WaldoNAVPadTextstore.TableNo := RecRef.Number();
        WaldoNAVPadTextstore.Textline := CopyStr(WaldoNAVPadTextClass.GetCurrentTextLine(), 1, MaxStrLen(WaldoNAVPadTextstore.Textline));
        WaldoNAVPadTextstore.Separator := WaldoNAVPadTextClass.GetSeparator();
        WaldoNavPadTextStore.Insert();
    end;

    local procedure OnBeforeSaveTexts(var Handled: Boolean);
    begin
    end;

    local procedure OnAfterSaveTexts();
    begin
    end;
}
