page 82100 "WaldoNAVPad"
{
    Caption = 'WaldoNAVPad';
    PageType = Card;

    layout
    {
        area(content)
        {
            grid(Control1100084005)
            {
                field(FullText; FullText)
                {
                    MultiLine = true;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
            }
        }
    }


    var
        FullText: Text;

    procedure SetText(Value: Text);
    begin
        FullText := Value;
    end;

    procedure GetText(): Text;
    begin
        exit(FullText);
    end;
}

