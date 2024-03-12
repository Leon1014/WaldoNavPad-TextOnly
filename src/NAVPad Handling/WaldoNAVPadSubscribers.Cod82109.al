codeunit 82109 "WaldoNAVPad Subscribers"
{
    trigger OnRun();
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Global Triggers", 'GetDatabaseTableTriggerSetup', '', false, false)]
    local procedure SetUpWaldoNAVPad_OnAfterGetDatabaseTableTriggerSetup(TableId: Integer; var OnDatabaseInsert: Boolean; var OnDatabaseModify: Boolean; var OnDatabaseDelete: Boolean; var OnDatabaseRename: Boolean);
    begin
        OnDatabaseRename := true;
        //making this TRUE for all tables should not be that concerning,
        //as renaming isn't something that happens too often ;-)

        //On the other hand, if we would do it like this:
        //  OnDatabaseRename := WaldoNAVPadClass.HasTexts(TableId);
        //Then it would fail for the first text we add to a table:
        //   - TriggerSetup would be false
        //   - if we add text and then rename, it wouldn't rename the text
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Global Triggers", 'OnDatabaseRename', '', false, false)]
    local procedure HandleWaldoNAVPadTexts_OnAfterOnDatabaseRename(RecRef: RecordRef; xRecRef: RecordRef);
    begin
        HandleRenameRecord(RecRef, xRecRef);
    end;

    local procedure HandleRenameRecord(var RecRef: RecordRef; var xRecRef: RecordRef);
    begin
        HandleBlobStore(RecRef, xRecRef);
        HandleTextStore(RecRef, xRecRef);
    end;

    local procedure HandleBlobStore(var RecRef: RecordRef; var xRecRef: RecordRef);
    var
        WaldoNAVPadBlobstore: Record "WaldoNAVPad Blobstore";
    begin
        WaldoNAVPadBlobstore.SetRange("Record ID", xRecRef.RecordId());
        WaldoNAVPadBlobstore.ModifyAll("Record ID", RecRef.RecordId(), false);
    end;

    local procedure HandleTextStore(var RecRef: RecordRef; var xRecRef: RecordRef);
    var
        WaldoNAVPadTextstore: Record "WaldoNAVPad Textstore";
    begin
        WaldoNAVPadTextstore.SetRange("Record ID", xRecRef.RecordId());
        WaldoNAVPadTextstore.ModifyAll("Record ID", RecRef.RecordId(), false);
    end;
}

