page 82149 "WaldoNAVPad Texts"
{
    PageType = List;
    SourceTable = "WaldoNAVPad Textstore";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field(RecordID; FORMAT(Rec."Record ID"))
                {
                    ApplicationArea = All;
                }
                field(Textline; Rec.Textline)
                {
                    ApplicationArea = All;
                }
                field(Separator; Rec.Separator)
                {
                    ApplicationArea = All;
                }
                field(TableNo; Rec.TableNo)
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

