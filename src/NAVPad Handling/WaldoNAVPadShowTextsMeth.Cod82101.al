codeunit 82101 "WaldoNAVPad ShowTexts Meth"
{
    trigger OnRun();
    begin
    end;

    procedure ShowTexts(Editable: Boolean; var RecRef: RecordRef; var ReturnWaldoNAVPadTextClass: Codeunit "WaldoNAVPad Text Class");
    var
        Handled: Boolean;
    begin
        OnBeforeShowTexts(RecRef, Handled);
        DoShowTexts(Editable, RecRef, ReturnWaldoNAVPadTextClass, Handled);
        OnAfterShowTexts(RecRef);
    end;

    local procedure DoShowTexts(Editable: Boolean; var RecRef: RecordRef; var ReturnWaldoNAVPadTextClass: Codeunit "WaldoNAVPad Text Class"; Handled: Boolean);
    var
        TextFromBlob: Text;
    begin
        if Handled then exit;

        TextFromBlob := GetTextFromWaldoNAVPadBlob(RecRef);

        LoadTextfromDialog(TextFromBlob, Editable, ReturnWaldoNAVPadTextClass);
    end;

    local procedure GetTextFromWaldoNAVPadBlob(var RecRef: RecordRef): Text;
    var
        TempBlob: Codeunit "Temp Blob";
        WaldoNAVPadBlobstore: Record "WaldoNAVPad Blobstore";
        ReaderStream: InStream;
        WriterStream: OutStream;
        TempText: Text;
    begin
        with WaldoNAVPadBlobstore do begin
            SETRANGE("Record ID", RecRef.RECORDID());
            if not FINDFIRST() then exit('');
            if not Blob.HASVALUE() then exit('');

            CALCFIELDS(Blob);
            Blob.CreateInStream(ReaderStream);
            TempBlob.CreateOutStream(WriterStream);
            ReaderStream.ReadText(TempText);
            WriterStream.WriteText(TempText);

            exit(GetTextFromBlob(TempBlob));
        end;
    end;

    local procedure LoadTextfromDialog(var TextFromBlob: Text; Editable: Boolean; var ResultWaldoNAVPadTextClass: Codeunit "WaldoNAVPad Text Class");
    var
        WaldoNAVPadTextstore: Record "WaldoNAVPad Textstore";
    begin
        with ResultWaldoNAVPadTextClass do begin
            Initialize(TextFromBlob, MAXSTRLEN(WaldoNAVPadTextstore.Textline));
            LoadTextFromDialog(Editable);
        end;
    end;

    local procedure GetTextFromBlob(var TempBlob: Codeunit "Temp Blob"): Text;
    var
        TextBigText: BigText;
        ReadStream: InStream;
    begin
        TempBlob.CreateInStream(ReadStream);
        TextBigText.READ(ReadStream);
        exit(FORMAT(TextBigText));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowTexts(var RecRef: RecordRef; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShowTexts(var RecRef: RecordRef);
    begin
    end;
}
