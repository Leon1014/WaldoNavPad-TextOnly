page 82150 "WaldoNAVPad Blobs"
{
    PageType = List;
    SourceTable = "WaldoNAVPad Blobstore";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(RecordID; FORMAT(Rec."Record ID"))
                {
                    ApplicationArea = All;
                }
                field(Blob; Rec.Blob.HasValue())
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

