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
        with WaldoNAVPadTextstore do
            SETRANGE("Record ID", RecRef.RECORDID());
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
        with WaldoNAVPadBlobstore do begin
            SETRANGE("Record ID", RecRef.RECORDID());
            DELETEALL(false);
        end;
    end;

    local procedure InsertWPNBlobForRecord(var Text: Text; var RecRef: RecordRef);
    var
        WaldoNAVPadBlobstore: Record "WaldoNAVPad Blobstore";
        TempBlob: Codeunit "Temp Blob";
        Writer: OutStream;
        Reader: InStream;
        ReadText: Text;
    begin
        GetBlobFromText(Text, TempBlob);
        TempBlob.CreateInStream(Reader);
        WaldoNAVPadBlobstore.Init();
        WaldoNAVPadBlobstore."Record ID" := RecRef.RecordId();
        WaldoNAVPadBlobstore.Blob.CreateOutStream(Writer);
        while not Reader.EOS do begin
            Reader.ReadText(ReadText);
            Writer.WriteText(ReadText);
        end;
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
        with WaldoNAVPadTextClass do
            if FINDFIRST() then
                repeat
                    InsertWPNText(GetCurrentTextLine(), RecRef);
                until NEXT() < 1;
    end;

    local procedure InsertWPNText(pTextline: Text; var RecRef: RecordRef);
    var
        WaldoNAVPadTextstore: Record "WaldoNAVPad Textstore";
    begin
        with WaldoNAVPadTextstore do begin
            INIT();

            Textline := copystr(pTextline, 1, MaxStrLen(Textline));
            "Record ID" := RecRef.RECORDID();
            TableNo := RecRef.NUMBER();

            INSERT();
        end;
    end;

    local procedure GetBlobFromText(Text: Text; var TempBlob: Codeunit "Temp Blob");
    var
        TextBigText: BigText;
        WriteStream: OutStream;
    begin
        TempBlob.CreateOutStream(WriteStream);
        TextBigText.AddText(Text);
        TextBigText.Write(WriteStream);
    end;

    local procedure OnBeforeSaveTexts(var Handled: Boolean);
    begin
    end;

    local procedure OnAfterSaveTexts();
    begin
    end;
}
